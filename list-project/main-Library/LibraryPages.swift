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
    let alignment: HorizontalAlignment = .center
    
    var dimensions: (width: CGFloat, height: CGFloat) {
        let screenWidth = UIScreen.main.bounds.width
        let n: CGFloat = max(screenWidth / 250, 1) // Minimum 1 column with 350px as base

        // Calculate width and height for ReturnedMovie
        let calculatedWidth = screenWidth / n
        let calculatedHeight = calculatedWidth / 16 * 9 // Aspect ratio of 16:9

        // Define a dictionary with item types as keys and a tuple for width and height as values
        let typeDimensions: [String: (width: CGFloat, height: CGFloat)] = [
            "Data_people": (width: 150, height: 200),
            "Data_list": (width: 150, height: 180),
            "ReturnedMovie": (width: calculatedWidth, height: calculatedHeight)
        ]

        // Check the type of the first item in the list
        if let firstItem = list.first {
            let typeName = String(describing: type(of: firstItem))
            return typeDimensions[typeName] ?? (width: 150, height: 180)
        }
        
        // Default dimensions if list is empty
        return (width: 150, height: 180)
    }

    
    var dynamicSpacing: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let numberOfColumns = max(Int(screenWidth / dimensions.width), 1)
        let totalSpacing = screenWidth - (CGFloat(numberOfColumns) * dimensions.width)
        return max(totalSpacing / CGFloat(numberOfColumns + 1), 10) // Ensure minimum spacing of 10
    }
    
    var columns: [GridItem] {
        let screenWidth = UIScreen.main.bounds.width
        let numberOfColumns = max(Int(screenWidth / dimensions.width), 1)
        return Array(repeating: GridItem(.flexible(minimum: dimensions.width)), count: numberOfColumns)
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: dynamicSpacing) {
            ForEach(list) { item in
                content(item)
                    .frame(height: dimensions.height)
                    .padding(.vertical,5)
            }
        }
        .padding(.horizontal)
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

                Rectangle()
                    .fill(Color.black.opacity(0.25))
                    .frame(width: width, height: height)
                
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
            .aspectRatio(aspectRatio, contentMode: .fit)
            .frame(width: width, height: height)
        }
    }
}

struct GridCountry: View {
    var imageSize: CGFloat = 150
    var country: Preview_country
    
    var body: some View {
        ZStack {
//            map pic
            
            Text(country.name)
                .font(.headline)
                .frame(maxWidth: imageSize)
                .multilineTextAlignment(.center)
        }
    }
}

struct GridCompany: View {
    var imageSize: CGFloat = 150
    var company: Preview_company
    
    var body: some View {
        VStack (alignment: .center) {
            let path = company.logo_path
            if let profilePath = path, !profilePath.isEmpty, let imgURL = URL(string: "https://image.tmdb.org/t/p/original/" + (path ?? "")) {
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
            
//            convert iso to name
            Text(company.name + (emoji(company.origin_country) ?? ""))
                .font(.headline)
                .frame(maxWidth: imageSize)
                .multilineTextAlignment(.center)
        }
    }
}

struct GridGenre: View {
    var imageSize: CGFloat = 150
    var genre: Preview_genre
    
    var body: some View {
        Text(genre.name)
            .font(.headline)
            .frame(maxWidth: imageSize)
            .multilineTextAlignment(.center)
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
        let dummyPeople = [
            Data_people(id: 42, original_name: "Lars von Trier", profile_path: "/rlUAvvpXwSA3Qihl3vDW7RtWagH.jpg", known_for_department: ""),
            Data_people(id: 2227, original_name: "Nicole Kidman", profile_path: "/lfW2cDigTcvuoe4k6UfCdGVE1R6.jpg", known_for_department: "")
        ]
        let dummyMovies: [ReturnedMovie] = [
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
        
//        TO TEST:
        let dummyCountry = [
            Preview_country(iso_3166_1: "SE", name: "Sweden"),
            Preview_country(iso_3166_1: "US", name: "United States"),
            Preview_country(iso_3166_1: "GB", name: "United Kingdom"),
            Preview_country(iso_3166_1: "CA", name: "Canada"),
            Preview_country(iso_3166_1: "FR", name: "France")
        ]
        let dummyCompany = [
            Preview_company(id: 25491, logo_path: nil, name: "Edith Film Oy", origin_country: ""),
            Preview_company(id: 2801, logo_path: "/bswb1PLLsKDUXMLgy42bZtCtIde.png", name: "Film i Väst", origin_country: "SE"),
            Preview_company(id: 7843, logo_path: "/v293yOJQyswsz3bLQ7eylTcsvdp.png", name: "4 1/2", origin_country: "NO")
        ]
        let dummyGenre = [
            Preview_genre(id: 28, name: "Action"),
            Preview_genre(id: 12, name: "Adventure"),
            Preview_genre(id: 16, name: "Animation"),
            Preview_genre(id: 99, name: "Documentary")
        ]
        
        ScrollView {
            VStack (alignment: .center) {
                LazyGridPage(list: dummyList) { listObject in
                    GridList(list: listObject)
                }
                Divider()
                LazyGridPage(list: dummyPeople) { listObject in
                    GridPerson(person: listObject)
                }
                Divider()
                LazyGridPage(list: dummyMovies) { listObject in
                    GridFilm(film: listObject)
                }
//              NEW STUFF  ==================================
                Divider()
                LazyGridPage(list: dummyCompany) { listObject in
                    GridCompany(company: listObject)
                }
                Divider()
                LazyGridPage(list: dummyCountry) { listObject in
                    GridCountry(country: listObject)
                }
                Divider()
                LazyGridPage(list: dummyGenre) { listObject in
                    GridGenre(genre: listObject)
                }
                
                
            }
        }
    }
}
