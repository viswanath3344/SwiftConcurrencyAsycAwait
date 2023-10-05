//
//  GlobalActorBootcamp.swift
//  SwiftConcurrencyAsycAwait
//
//  Created by Ponthota, Viswanath Reddy (Cognizant) on 05/10/23.
//

import SwiftUI

@globalActor final class MyFirstGlobalActor {
    typealias ActorType = GlobalActorDataManager
    static var shared = GlobalActorDataManager()
    
}

actor GlobalActorDataManager {
    func getDataFromDatabase() -> [String]{
        return ["One", "Two", "Three", "Four", "Five"]
    }
}

class GlobalActorBootcampViewModel: ObservableObject {
  @MainActor @Published var items:[String] = []
    let manager = MyFirstGlobalActor.shared
    
   @MyFirstGlobalActor func getData() {
       Task {
           let newItems = await manager.getDataFromDatabase()
           await MainActor.run {
               items = newItems
           }
       }
    }
}

struct GlobalActorBootcamp: View {
    @StateObject var VM = GlobalActorBootcampViewModel()
   
    var body: some View {
        VStack {
            List(VM.items, id: \.self) { item in
                Text(item).font(.body)
            }
        }
        .task {
            await VM.getData()
        }
    }
}

struct GlobalActorBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        GlobalActorBootcamp()
    }
}
