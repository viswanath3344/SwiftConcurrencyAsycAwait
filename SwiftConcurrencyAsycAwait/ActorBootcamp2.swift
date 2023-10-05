//
//  ActorBootcamp2.swift
//  SwiftConcurrencyAsycAwait
//
//  Created by Ponthota, Viswanath Reddy (Cognizant) on 05/10/23.
//

import SwiftUI

class ActorBootcamp2DataManager {
    static let shared = ActorBootcamp2DataManager()
    private init() {}
    
    
    // Create a Serial queue and wrap the shared resource under this queue. To avoid racing condition.
    let lock = DispatchQueue(label: "com.MyApp.ActorBootcamp")
    
    var data: [String] = []
    
    
    func getRandomElement(completion: @escaping (String?) -> Void) {
        lock.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            completion(self.data.randomElement())
        }
    }
}

actor ActorBootcamp2DataManagerWithActors {
    
    // Create a Serial queue and wrap the shared resource under this queue. To avoid racing condition.
    
    var data: [String] = []
    
    func getRandomElement() -> String? {
        self.data.append(UUID().uuidString)
        print(Thread.current)
        return self.data.randomElement()
    }
    
    nonisolated func getName() -> String {
        return "NAME"
    }
}

struct Home: View {
    let manager = ActorBootcamp2DataManagerWithActors()
    @State var text: String = ""
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color(.gray)
            Text(text).font(.body)
        }.edgesIgnoringSafeArea([.top])
            .onReceive(timer) { _ in
                print(manager.getName())
                DispatchQueue.global(qos: .background).async {
                    Task {
                        if let data = await  manager.getRandomElement() {
                            await MainActor.run(body: {
                                text = data
                            })
                        }
                        
                    }
                }
            }
    }
}

struct Settings: View {
    
    let manager = ActorBootcamp2DataManagerWithActors()
    @State var text: String = ""
    
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        ZStack {
            Color(.systemYellow)
            Text(text).font(.body)
        }.edgesIgnoringSafeArea([.top])
            .onReceive(timer) { _ in
                DispatchQueue.global(qos: .background).async {
                    Task {
                        if let data = await  manager.getRandomElement() {
                            await MainActor.run(body: {
                                text = data
                            })
                            
                        }
                    }
                }
            }
    }
}

struct ActorBootcamp2: View {
    var body: some View {
        TabView {
            Home().tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            Settings().tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
        }
    }
}

struct ActorBootcamp2_Previews: PreviewProvider {
    static var previews: some View {
        ActorBootcamp2()
    }
}
