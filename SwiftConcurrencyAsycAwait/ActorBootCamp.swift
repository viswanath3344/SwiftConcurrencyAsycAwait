//
//  ContentView.swift
//  SwiftConcurrencyAsycAwait
//
//  Created by Ponthota, Viswanath Reddy (Cognizant) on 03/10/23.
//

import SwiftUI

actor ActorBootcampDataManager {
    var name: String = ""
    var id: Int = 0
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
    
    func setName(name: String) {
        self.name = name
    }
    
    func setId(id: Int){
        self.id = id
    }
}

struct ActorBootCamp: View {
    let manager = ActorBootcampDataManager(name: "Viswa", id: 1)
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .task {
                await print(manager.name, manager.id)
                await manager.setName(name: "reddy")
                await print(manager.name)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ActorBootCamp()
    }
}
