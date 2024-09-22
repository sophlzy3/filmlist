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
    let alignment: HorizontalAlignment = .center // Can be passed as parameter

    
    var columns: [GridItem] {
        let screenWidth = UIScreen.main.bounds.width
        var itemWidth: CGFloat
        
        if list.first is Data_people {
            itemWidth = 300  // Width for GridPerson items
        } else if list.first is ReturnedMovie {
            //            itemWidth = screenWidth - 40  // Full screen width for GridFilm items
            itemWidth = 200
        } else {
            itemWidth = 150  // Default width
        }
        
        let numberOfColumns = max(Int(screenWidth / itemWidth), 1) // Ensure at least 1 column
        return Array(repeating: GridItem(.flexible(minimum: itemWidth)), count: numberOfColumns)
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(list) { item in
                content(item)  // Construct the view using the closure
//                    .frame(minWidth: 150, maxWidth: .infinity, alignment: .leading)
                    .padding(5)
            }
        }
        .frame(maxWidth: .infinity)
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
                        .clipShape(Circle())
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
    var aspectRatio: CGFloat = 16.0 / 9.0
    var film: ReturnedMovie
    
    var descriptionString: String {
        let releaseYear = film.release_date?.prefix(4) ?? "Date Unknown"
        let genreNames = film.genre_ids.compactMap { genreIDs[$0] }
        let genreString = genreNames.isEmpty ? "No genre" : genreNames.prefix(2).joined(separator: "/")
        let englishName = languageIDs[film.original_language]?["english_name"] ?? "Unknown"
        return "\(releaseYear) • \(genreString) • \(englishName)"
    }

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = width / aspectRatio // Maintain the aspect ratio
            let imageURL = URL(string: "https://image.tmdb.org/t/p/original/" + (film.backdrop_path ?? ""))!
            
            ZStack(alignment: .bottomLeading) {
                // Background Image
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: width, height: height) // Match the frame to the calculated size
                            .clipped()
                    case .failure:
                        Color(UIColor.systemGray3)
                    @unknown default:
                        Color(UIColor.systemGray3)
                    }
                }

                // Overlay Rectangle
                Rectangle()
                    .fill(Color.black.opacity(0.25))
                    .frame(width: width, height: height) // Match the frame to the calculated size
                
                // Text Content
                VStack(alignment: .leading) {
                    Text(film.title)
                        .foregroundColor(.white)
                        .font(.system(size: width * 0.08)) // Dynamic font size
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .minimumScaleFactor(0.5)
                    
                    Spacer()
                        .frame(height: width * 0.04) // Adjust based on the dynamic size
                    
                    Text(descriptionString)
                        .foregroundColor(.white)
                        .font(.system(size: width * 0.05)) // Dynamic font size for description
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.5)
                }
                .padding(EdgeInsets(top: 40, leading: 20, bottom: 30, trailing: 40))
            }
            .aspectRatio(aspectRatio, contentMode: .fit) // Maintain the aspect ratio for the entire ZStack
            .frame(maxWidth: .infinity) // Ensure it uses the full width
        }
    }
}


//struct GridFilm: View {
////    @State private var originalFrameSize: CGSize?
////    var frameWidth: CGFloat = 350
//    var aspectRatio: CGFloat = 16.0 / 9.0
//    var film: ReturnedMovie
//    var descriptionString: String {
//        let releaseYear = film.release_date?.prefix(4) ?? "Date Unknown"
//        
//        var genreString: String {
//            let genreNames = film.genre_ids.compactMap { genreIDs[$0] }
//            
//            if genreNames.isEmpty {
//                return "No genre"
//            } else if genreNames.count <= 2 {
//                return genreNames.joined(separator: "/")
//            } else {
//                return genreNames.prefix(2).joined(separator: "/")
//            }
//        }
//        // Define englishName outside the conditional to use it later
//        var englishName = "Unknown"
//        
//        // Assuming languageIDs is defined as [String: [String: String]]
//        if let languageInfo = languageIDs[film.original_language] {
//            englishName = languageInfo["english_name"] ?? "Unknown"
//        }
//        
//        return "\(releaseYear) • \(genreString) • \(englishName)"
//    }
//
//    var body: some View {
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
//                    Color(UIColor.systemGray3)
//                }
//            }
//            Rectangle()
//                .fill(Color.black.opacity(0.25))
//            
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
//        .aspectRatio(aspectRatio, contentMode: .fit) // Maintain fixed aspect ratio for the entire ZStack
//        .frame(maxWidth: .infinity) // Make it adjustable in width
//    }
//}


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
        
        ScrollView {
            VStack (alignment: .center) {
//                LazyGridPage(list: dummyList) { listObject in
//                    GridList(list: listObject)
//                }
//                Divider()
//                LazyGridPage(list: dummyPeople) { listObject in
//                    GridPerson(person: listObject)
//                }
//                Divider()
                LazyGridPage(list: sampleMovies) { listObject in
                    GridFilm(film: listObject)
                }
                
            }
        }
    }
}
