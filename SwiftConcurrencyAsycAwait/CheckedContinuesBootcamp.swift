//
//  CheckedContinuesBootcamp.swift
//  SwiftConcurrencyAsycAwait
//
//  Created by Ponthota, Viswanath Reddy (Cognizant) on 04/10/23.
//

import SwiftUI

class CheckedContinuesBootcampNetworkManager {
    func getImage(url: URL) async throws -> UIImage {
        
       return try await withCheckedThrowingContinuation { continuation in
           
            URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
                if let data = data, let image = UIImage(data: data)  {
                        continuation.resume(returning: image)
                }
                else if let error = error {
                    continuation.resume(throwing: error)
                }else {
                    continuation.resume(throwing: URLError(.badServerResponse))
                }
            }.resume()
        }
        
    }
}

class CheckedContinuesBootcampViewModel:ObservableObject {
    @Published var image:UIImage?

    func downloadImage() async {
        guard let url = URL(string: "https://random.imagecdn.app/500/150") else {
            return
        }
        
        do {
            let image = try await CheckedContinuesBootcampNetworkManager().getImage(url: url)
            
            await MainActor.run(body: {
                self.image = image
            })
            
        } catch  {
            print(error)
        }
    }
}

struct CheckedContinuesBootcamp: View {
    @StateObject var VM = CheckedContinuesBootcampViewModel()
    var body: some View {
        VStack {
            if let image = VM.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }else {
                Text("No Image available")
            }
        }.task {
            await VM.downloadImage()
        }
    }
}

struct CheckedContinuesBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CheckedContinuesBootcamp()
    }
}
