//
//  AsyncLetBootcamp.swift
//  SwiftConcurrencyAsycAwait
//
//  Created by Ponthota, Viswanath Reddy (Cognizant) on 04/10/23.
//

import SwiftUI

struct AsyncLetBootcamp: View {
    @State var images = [UIImage]()
    
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        ScrollView {
            VStack {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    }
                }.padding()
            }
        }
        .task {
            do {
                async let image1 = getImage()
                async let image2 = getImage()
                async let image3 = getImage()
                async let image4 = getImage()
                
                let (dImage1, dImage2, dImage3, dImage4) = await (try image1, try image2, try image3, try image4)
                
                
                images.append(contentsOf: [dImage1, dImage2, dImage3, dImage4])
                
            }catch {
                print(error)
            }
            
        }
    }
}

func getImage() async throws -> UIImage {
    guard let url = URL(string: "https://random.imagecdn.app/500/150") else {
        throw URLError(.badURL)
    }
    let response = try? Data(contentsOf: url)
    
    guard let data = response,
          let image = UIImage(data: data) else {
        throw URLError(.badServerResponse)
    }
    
    return image
}

struct AsyncLetBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncLetBootcamp()
    }
}
