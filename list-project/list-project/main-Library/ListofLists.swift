//
//  ListofLists.swift
//  list-project
//
//  Created by Sophie Liu on 2024-09-10.
//

import SwiftUI
import Foundation

struct ListPage: View {
    var list: [Data_list]
    
    // Define a grid layout that adapts to the screen size
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(list) { listObject in
                    RowList(list: listObject)
                        .frame(minWidth: 150, maxWidth: .infinity, alignment: .leading)
                        .padding(5)
                }
            }
            .padding()
        }
        .navigationTitle("Lists")
    }
}

struct RowList: View {
    var imageSize: CGFloat = 150
    var list: Data_list
    
    var body: some View {
        VStack (alignment: .center) {
            if !list.cover.isEmpty, let imgURL = URL(string: list.cover) {
                AsyncImage(url: imgURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: imageSize, height: imageSize)
                        .clipped()
                        .cornerRadius(7)
                } placeholder: {
                    ProgressView()
                }
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: imageSize, height: imageSize)
            }
            Text(list.name)
                .font(.headline)
                .frame(maxWidth: imageSize)
                .multilineTextAlignment(.center)
        }
        .navigationTitle("Lists")
    }
}

struct ListPage_Previews: PreviewProvider {
    static var previews: some View {
        let dummyList = [
            Data_list(id: 1, name: "To-Watch", type: "aaa", cover: "https://cdn.britannica.com/39/116039-050-9FEAC4FA/reconstruction-ruins-Ishtar-Gate-Babylon-Al-Hillah-Iraq.jpg", imgs: [
                "/vINgGecnz95iDL6fjQMARDsocgG.jpg",
                "/sNACthNvOoSTJxo240N5sqa67ip.jpg"
              ]),
            Data_list(id: 2, name: "Metropolis", type: "To-Watch", cover: "https://m.media-amazon.com/images/M/MV5BNDM1MjkwMTgzNV5BMl5BanBnXkFtZTgwNzc4ODUxMzE@._V1_.jpg", imgs: [
                "/vINgGecnz95iDL6fjQMARDsocgG.jpg",
                "/sNACthNvOoSTJxo240N5sqa67ip.jpg"
              ]),
            Data_list(id: 3, name: "Gaga", type: "ppppfff", cover: "https://wwd.com/wp-content/uploads/2023/06/MEGA989664_002.jpg?crop=0px%2C404px%2C3600px%2C2015px&resize=1000%2C563", imgs: [
                "/vINgGecnz95iDL6fjQMARDsocgG.jpg"
              ])
        ]
        
        ListPage(list: dummyList)
    }
}
