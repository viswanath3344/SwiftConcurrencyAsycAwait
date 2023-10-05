//
//  SendableProtocolBootcamp.swift
//  SwiftConcurrencyAsycAwait
//
//  Created by Ponthota, Viswanath Reddy (Cognizant) on 05/10/23.
//

import SwiftUI

actor SendableDataManager {
    func getWelcomeMessage(info: MyInfoClass){ }
}

// structs are value types, so also confirmed to sendable protocol.
struct MyInfo {
    var name: String
}

final class MyInfoClass: @unchecked Sendable {
    var name: String = ""
    let lock = DispatchQueue(label: "com.MyApp.MyInfoClass")
    
    init(name: String) {
        self.name = name
    }
    
    func updateInfo(name: String){
        lock.async {
            self.name = name
        }
    }
}

class SendableProtocolBootcampVM : ObservableObject {
    @Published var name: String = ""
    var manager = SendableDataManager()
    
    init(name: String) {
        self.name = name
    }
    
    func getGreetingMessage() async {
        await manager.getWelcomeMessage(info: MyInfoClass(name: "Viswa"))
    }
}

struct SendableProtocolBootcamp: View {
    @StateObject var VM = SendableProtocolBootcampVM(name: "Reddy")
    var body: some View {
        Text(VM.name)
    }
}

struct SendableProtocolBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        SendableProtocolBootcamp()
    }
}
