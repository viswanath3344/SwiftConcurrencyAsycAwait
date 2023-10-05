//
//  AsyncAwaitBootcamp.swift
//  SwiftConcurrencyAsycAwait
//
//  Created by Ponthota, Viswanath Reddy (Cognizant) on 03/10/23.
//

import SwiftUI

class NetworkManager {
    func getImage(_ imageUrl: String = "https://random.imagecdn.app/500/150") async throws -> UIImage? {
        guard let url = URL(string: imageUrl) else {
            throw URLError(.badURL)
        }
        let response = try? Data(contentsOf: url)
        
        guard let data = response else {
            throw URLError(.badServerResponse)
        }
        
        return UIImage(data: data)
    }
}

class AsyncAwaitBootCampViewModel: ObservableObject {
   @Published var image1: UIImage?
   @Published var image2: UIImage?
    
    func getImageFromAsync() async {
        let image = try? await NetworkManager().getImage()
        
        await MainActor.run {
            self.image1 = image
        }
    }
    
    func getImage1FromAsync() async {
        let image = try? await NetworkManager().getImage()
        
        await MainActor.run {
            self.image2 = image
        }
    }
}

struct AsyncAwaitBootcamp: View {
    @StateObject var vm = AsyncAwaitBootCampViewModel()
    
    var body: some View {
        VStack{
            if let image = vm.image1 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200)
            }else {
                Text("No preview")
            }
            
            if let image = vm.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200)
            }
        }.padding()
        .task {
            
        }
        .task {
            await vm.getImage1FromAsync()
        }
        
    }
}

struct AsyncAwaitBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwaitBootcamp()
    }
}
