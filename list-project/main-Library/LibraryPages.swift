//
//  ListofLists.swift
//  list-project
//
//  Created by Sophie Liu on 2024-09-10.
//

import SwiftUI
import Foundation


struct LazyGridPage<Item: Identifiable, Content: View>: View {
    var list: [Item]
    let content: (Item) -> Content
    
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(list) { item in
                    content(item)  // Construct the view using the closure
                        .frame(minWidth: 150, maxWidth: .infinity, alignment: .leading)
                        .padding(5)
                }
            }
            .padding()
        }
        .navigationTitle("Lists")
    }
}

struct GridList: View {
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

struct GridPerson: View {
    var imageSize: CGFloat = 150
    var person: Data_people
    
    var body: some View {
        VStack (alignment: .center) {
            if let profilePath = person.profile_path, !profilePath.isEmpty, let imgURL = URL(string: "https://image.tmdb.org/t/p/original/" + (person.profile_path ?? "")) {
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
            
            Text(person.original_name)
                .font(.headline)
                .frame(maxWidth: imageSize)
                .multilineTextAlignment(.center)
        }
    }
}

struct GridFilm: View {
//    @State private var originalFrameSize: CGSize?
    var frameWidth: CGFloat = 350
    var film: ReturnedMovie
    var descriptionString: String {
        let releaseYear = film.release_date?.prefix(4) ?? "Date Unknown"
        
        var genreString: String {
            let genreNames = film.genre_ids.compactMap { genreIDs[$0] }
            
            if genreNames.isEmpty {
                return "No genre"
            } else if genreNames.count <= 2 {
                return genreNames.joined(separator: "/")
            } else {
                return genreNames.prefix(2).joined(separator: "/")
            }
        }
        
        // Define englishName outside the conditional to use it later
        var englishName = "Unknown"
        
        // Assuming languageIDs is defined as [String: [String: String]]
        if let languageInfo = languageIDs[film.original_language] {
            englishName = languageInfo["english_name"] ?? "Unknown"
        }
        
        return "\(releaseYear) • \(genreString) • \(englishName)"
    }

    var body: some View {
        HStack {
            Text(film.title)
            Text(descriptionString)
        }
        .frame(width: 350)
    }
//        let imageURL = URL(string: "https://image.tmdb.org/t/p/original/" + (film.backdrop_path ?? ""))!
//        ZStack (alignment: .bottomLeading){
//            AsyncImage(url: imageURL) { phase in
//                switch phase {
//                case .empty:
//                    ProgressView()
//                case .success(let image):
//                    image
//                        .resizable()
//                        .scaledToFill()
////                        .edgesIgnoringSafeArea(.horizontal)
//                        .clipped()
//                        .foregroundColor(.secondary)
//                case .failure:
//                    Color(UIColor.systemGray3)
//                @unknown default:
//                    EmptyView()
//                }
//            }

//            Rectangle()
//                .fill(Color.black.opacity(0.25))
//                .frame(width: 350, height: 350/16*9)
            
//            VStack (alignment:.leading){
//                Text(film.title)
//                    .foregroundColor(.white)
//                    .font(.system(size: 30))
//                    .fontWeight(.bold)
//                    .lineLimit(2)
//                    .truncationMode(.tail)
//                    .frame(width:.infinity)
//                Spacer()
//                    .frame(height:10)
//                Text(descriptionString)
//                    .foregroundColor(.white)
//                    .fontWeight(.bold)
//                    .font(.system(size:15))
//            }
//            .padding(EdgeInsets(top: 40, leading: 20, bottom: 30, trailing: 40))
//        }
//        .frame(width: frameWidth, height: frameWidth/16*9)
//    }
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
        
        let dummyPeople = [
            Data_people(id: 42, original_name: "Lars von Trier", profile_path: "/rlUAvvpXwSA3Qihl3vDW7RtWagH.jpg", known_for_department: ""),
            Data_people(id: 2227, original_name: "Nicole Kidman", profile_path: "/lfW2cDigTcvuoe4k6UfCdGVE1R6.jpg", known_for_department: "")
        ]
        
        let sampleMovies: [ReturnedMovie] = [
            ReturnedMovie(
                id: 1,
                title: "Inception",
                backdrop_path: "/s3TBrRGB1iav7gFOCNx3H31MoES.jpg",
                poster_path: "/qmDpIHrmpJINaRKAfWQfftjCdyi.jpg",
                release_date: "2010-07-16",
                genre_ids: [28, 12, 878],
                original_language: "en",
                overview: "A skilled thief is offered a chance to erase his past crimes in exchange for infiltrating the mind of a CEO."
            ),
            ReturnedMovie(
                id: 2,
                title: "Interstellar",
                backdrop_path: "/rAiYTfKGqDCRIIqo664sY9XZIvQ.jpg",
                poster_path: "/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg",
                release_date: "2014-11-05",
                genre_ids: [12, 878],
                original_language: "en",
                overview: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival."
            )
        ]
        
        VStack {
//            LazyGridPage(list: dummyList) { listObject in
//                GridList(list: listObject)
//            }
//            
//            Divider()
//            
            LazyGridPage(list: dummyPeople) { listObject in
                GridPerson(person: listObject)
            }
            
            Divider()
            LazyGridPage(list: sampleMovies) { listObject in
                GridFilm(film: listObject)
            }
        }
    }
}
