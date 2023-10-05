//
//  TaskGroupBootcamp.swift
//  SwiftConcurrencyAsycAwait
//
//  Created by Ponthota, Viswanath Reddy (Cognizant) on 04/10/23.
//

import SwiftUI


class TaskGroupViewModel: ObservableObject {
    @Published var images = [UIImage]()
    
    func getImages() async {
        do {
            let images1 = try await getDownloadImages()
            
            await MainActor.run {
                self.images = images1
            }
            
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    func getDownloadImages() async throws -> [UIImage]{
        
        let imageUrls = [
            "https://random.imagecdn.app/500/150",
            "https://random.imagecdn.app/500/150",
            "https://random.imagecdn.app/500/150",
            "https://random.imagecdn.app/500/150",
            "https://random.imagecdn.app/500/150",
            "https://random.imagecdn.app/500/150"
        ]
        
       return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            
           var downloadImages:[UIImage] = [UIImage]()
           downloadImages.reserveCapacity(imageUrls.count)
           
           for imageUrl in imageUrls {
               group.addTask {
                   try await NetworkManager().getImage(imageUrl)
               }
           }
           
           for try await image in group {
               if let image = image {
                   downloadImages.append(image)
               }
           }
           
           return downloadImages
        }
    }
}

struct TaskGroupBootcamp: View {
    @StateObject var vm = TaskGroupViewModel()
    
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        ScrollView {
            VStack {
                LazyVGrid(columns: columns) {
                    ForEach(vm.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    }
                }.padding()
            }
        }
        .task {
            await vm.getImages()
        }
    }
}

struct TaskGroupBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TaskGroupBootcamp()
    }
}
