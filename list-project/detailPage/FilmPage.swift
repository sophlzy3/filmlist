//
//  FilmSpecifics.swift
//  list-project
//
//  Created by Sophie Liu on 2023-07-05.
//

import SwiftUI

struct FilmPage: View {
    var film: Preview_film
    var cast: Preview_cast_crew
    var source: String // "search" or "library"
    
    var body: some View {
        ScrollView {
            TitlePreview(film: film, cast: cast)
                .frame(height:450)
            VStack (alignment:.leading) {
                if source == "search" {
                    SynopsisPreview(film: film)
                    Spacer()
                        .frame(height:20)
                    CastPreview(cast: cast)
                    Divider()
                }
                FilmReview(filmID: film.id)
                //                    AwardsPreview()
                //                    Divider()
                //                    IncludedPreview()
//                Divider()
                //                    ReceptionPreview()
                //                    Divider()
            }
            .padding(EdgeInsets(top:0, leading: 26, bottom: 0, trailing: 26))
        }
    }
}


// title struct
struct TitlePreview: View {
    var film: Preview_film
    var cast: Preview_cast_crew
    
    var titleString: String {
        //        director
        var directors: [String] = []
        for person in cast.crew {
            if person.job == "Director" {
                directors.append(person.original_name)
            }
        }
        var directorNames: String = ""
        if directors.count > 3 {
            directorNames += "\(directors[0]), \(directors[1]), \(directors[2]), and \(directors.count - 3) more"
        } else {
            directorNames = directors.joined(separator: ", ")
        }
        
        //        language
        var languages: [String] = []
        for language in film.spoken_languages {
            languages.append(language.english_name)
        }
        
        var title_languages: String = ""
        if languages.count > 1 {
            title_languages += "\(languages[0]), \(languages[1])"
        } else {
            title_languages = languages.joined(separator: ", ")
        }
        
        
        
        return "Dir. \(directorNames)"
            
    }
    
    var dateString: String {
        //        title_date
        var title_date: String = ""
        if let releaseDate = film.release_date, !releaseDate.isEmpty {
            title_date += String(releaseDate.prefix(4))
        } else {
            title_date += "Date Unknown"
        }
        
        
        //        country
        var countries: [String] = []
        for country in film.production_countries {
            countries.append(country.name)
        }
        
        var title_country: String = ""
        if countries.count >= 1 {
            title_country.append(countries[0])
        } else {
            title_country += "Country Unknown"
        }
        
       return "\(title_country), \(title_date)"
    }

    var genreString: String {
        var genres: [String] = []
        
        for genre in film.genres {
            genres.append(genre.name)
        }
        
        var title_genre: String = ""
        if genres.count > 3 {
            title_genre += "\(genres[0]), \(genres[1]), \(genres[2]), and \(genres.count - 3) more"
        } else {
            title_genre = genres.joined(separator: ", ")
        }
        
        return "\(title_genre)"
    }
    
    var runtimeString: some View {
        HStack {
            Image(systemName: "clock.fill")
            Text("\(film.runtime) min")
                .fontWeight(.semibold)
                .foregroundColor(Color(UIColor.systemGray4))
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment:.bottomLeading) {
                let imageURL = URL(string: "https://image.tmdb.org/t/p/original/" + (film.backdrop_path ?? ""))!

                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width:.infinity, height:.infinity)
                        
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        
                    case .failure:
                        Color(UIColor.systemGray)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                Rectangle()
                    .fill(Color.black.opacity(0.3))
                    .frame(width:geometry.size.width, height:geometry.size.height)
                
                VStack(alignment:.leading) {
                    Text(film.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(titleString)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
//                        .foregroundColor(Color(UIColor.systemGray4))
                    
                    Spacer()
                        .frame(height:5)
                    
                    Text(dateString)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(UIColor.systemGray4))
                    
//                    Spacer()
//                        .frame(height:5)
                    
                    Text(genreString)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(UIColor.systemGray4))
                    
                    Spacer()
                        .frame(height:5)
                    
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(Color(UIColor.systemGray4))
                        Text("\(film.runtime) mins")
                            .fontWeight(.semibold)
                            .foregroundColor(Color(UIColor.systemGray4))
                    }
                        
                    
                    Spacer()
                        .frame(height:20)
                }
                .padding(EdgeInsets(top:0, leading: 26, bottom: 0, trailing: 26))
            }
            .padding(EdgeInsets(top:0, leading: 0, bottom: 20, trailing: 0))
        }
    }
}

//synopsis
struct SynopsisPreview: View {
    var film: Preview_film
    var body: some View {
        VStack (alignment:.leading){
            Text("Synopsis")
                .font(.headline)
                .foregroundColor(.black)
                .fontWeight(.bold)
                .padding(EdgeInsets(top:5, leading: 0, bottom: 5, trailing: 0))
            
            if let overview = film.overview {
                Text(overview)
            } else {
                Text("None.")
            }
        }
    }
}

//cast and crew
struct CastPreview: View {
    var cast: Preview_cast_crew
    
    var body: some View {
        VStack (alignment:.leading){
            NavigationLink(destination: CastAndCrew()) {
                HStack{
                    Text("Cast")
                        .font(.headline)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                    Image(systemName:"chevron.right")
                        .foregroundColor(.secondary)
                }
            }
            .padding(EdgeInsets(top:5, leading: 0, bottom: 5, trailing: 0))
            
            ScrollView (.horizontal) {
                HStack (alignment:.top){
                    ForEach(0..<min(cast.cast.count, 5), id: \.self) { index in
                        CastCardPreview(person: cast.cast[index])
                        Spacer()
                            .frame(width:30)
                    }
                }
            }
        }
    }
}

struct CastCardPreview: View {
    var person: Preview_people
    let image_width = CGFloat(110)
    
    var body: some View {
        VStack (alignment:.center){
            if let path = person.profile_path {
                let imageURL = URL(string: "https://image.tmdb.org/t/p/original/\(path)")!
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: image_width)
                            .aspectRatio(0.67, contentMode: .fit)
                        
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: image_width)
                        
                    case .failure:
                        Color(UIColor.systemGray)
                            .aspectRatio(0.67, contentMode: .fit)
                            .frame(width: image_width)
                        
                    @unknown default:
                        EmptyView()
                    }
                }
                
            }
            Spacer()
                .frame(height:15)
            Text(person.original_name)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: false)
                .multilineTextAlignment(.center)
                .frame(alignment: .center)
            Text(person.character!)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: false)
                .multilineTextAlignment(.center)
                .frame(alignment: .center)
                .foregroundColor(.secondary)
        }
        .frame(width:image_width, height:.infinity)
    }
}

// awards: NOT USED FOR NOW
struct AwardsPreview: View {
    var body: some View {
        VStack (alignment:.leading){
            NavigationLink(destination: AwardsPage()) {
                HStack{
                    Text("Awards")
                        .font(.headline)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                    Image(systemName:"chevron.right")
                        .foregroundColor(.secondary)
                }
            }
            .padding(EdgeInsets(top:5, leading: 0, bottom: 5, trailing: 0))
            
            Text("AWARDS PREVIEW")
        }
    }
}

// reception
struct ReceptionPreview: View {
    var body: some View {
        VStack (alignment:.leading){
            NavigationLink(destination: ReceptionPage()) {
                HStack{
                    Text("Reception")
                        .font(.headline)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                    Image(systemName:"chevron.right")
                        .foregroundColor(.secondary)
                }
            }
            .padding(EdgeInsets(top:5, leading: 0, bottom: 5, trailing: 0))
            
            Text("reception PREVIEW")
        }
    }
}

// similar films
struct SimilarPreview: View {
    var body: some View {
        VStack (alignment:.leading){
            NavigationLink(destination: SimilarPage()) {
                HStack{
                    Text("Similar Movements and Films")
                        .font(.headline)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                    Image(systemName:"chevron.right")
                        .foregroundColor(.secondary)
                }
            }
            .padding(EdgeInsets(top:5, leading: 0, bottom: 5, trailing: 0))
            
            Text("similar PREVIEW")
        }
    }
}

//included
struct IncludedPreview: View {
    var body: some View {
        VStack (alignment:.leading){
            NavigationLink(destination: IncludedPage()) {
                HStack{
                    Text("Included in Groups")
                        .font(.headline)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        Image(systemName:"chevron.right")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(EdgeInsets(top:5, leading: 0, bottom: 5, trailing: 0))
                
                Text("included PREVIEW")
            }
        }
    }

    struct FilmReview: View {
        var filmID: Int
        @State private var cinematographyRating: Int = 0
        @State private var editingRating: Int = 0
        @State private var costumeMakeupRating: Int = 0
        @State private var lightingRating: Int = 0
        @State private var stagingRating: Int = 0
        @State private var settingPropsRating: Int = 0
        @State private var narrativeComment: String = ""
        
        func updateRating(field: String, value: Int, movieId: Int) async {
            do {
                let updateData: [String: Int] = [field: value]
                try await DatabaseManager.shared.updateItem(
                    database: "movies",
                    conditions: [("eq", "id", movieId)],
                    newValue: updateData
                )
            } catch {
                print("Error updating rating: \(error)")
            }
        }

        func updateNote(field: String, value: String, movieId: Int) async {
            do {
                let updateData: [String: String] = [field: value]
                try await DatabaseManager.shared.updateItem(
                    database: "movies",
                    conditions: [("eq", "id", movieId)],
                    newValue: updateData
                )
            } catch {
                print("Error updating note: \(error)")
            }
        }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Film Review")
                // .font(.title)
                .font(.headline)
                .foregroundColor(.black)
                .fontWeight(.bold)
                .padding(EdgeInsets(top:5, leading: 0, bottom: 5, trailing: 0))
            
            RatingRow(title: "Cinematography", rating: $cinematographyRating) { newRating in
                Task {
                    await updateRating(field: "cinematography", value: newRating, movieId: filmID)
                }
            }
            
            RatingRow(title: "Editing", rating: $editingRating) { newRating in
                Task {
                    await updateRating(field: "editing", value: newRating, movieId: filmID)
                }
            }
            
            RatingRow(title: "Costume / Makeup", rating: $costumeMakeupRating) { newRating in
                Task {
                    await updateRating(field: "costume_makeup", value: newRating, movieId: filmID)
                }
            }
            
            RatingRow(title: "Lighting", rating: $lightingRating) { newRating in
                Task {
                    await updateRating(field: "lighting", value: newRating, movieId: filmID)
                }
            }
            
            RatingRow(title: "Staging", rating: $stagingRating) { newRating in
                Task {
                    await updateRating(field: "staging", value: newRating, movieId: filmID)
                }
            }
            
            RatingRow(title: "Setting / Props", rating: $settingPropsRating) { newRating in
                Task {
                    await updateRating(field: "setting_props", value: newRating, movieId: filmID)
                }
            }
            
            VStack(alignment: .leading) {
                Text("Narrative (Implicit / Symptomatic Meaning)")
                    .font(.headline)
                    .padding(.top, 16)
                TextEditor(text: $narrativeComment)
                    .frame(height: 100)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                    .onChange(of: narrativeComment) { newValue in
                        Task {
                            await updateNote(field: "narrative", value: newValue, movieId: filmID)
                        }
                    }
            }
        }
    }
}

struct RatingRow: View {
    let title: String
    @Binding var rating: Int
    let onRatingChanged: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            HStack {
                ForEach(1...5, id: \.self) { i in
                    Image(systemName: i <= rating ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .onTapGesture {
                            rating = i
                            onRatingChanged(i)
                        }
                }
                if rating > 0 {
                    Button(action: {
                        rating = 0
                        onRatingChanged(0)
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// preview
struct FilmDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        FilmPage(
            film: Preview_film(
                backdrop_path: "/r3xsFBD1VTUusk393bBc7SsDUJe.jpg",budget: 100000,
                genres: [
                    Preview_genre(id:80, name:"Crime"),
                    Preview_genre(id:18, name:"Drama"),
                    Preview_genre(id:53, name:"Thriller")
                ],
                id: 553,
                imdb_id: "tt0276919",
                overview: "blah blah blah blah test code test code",
                poster_path: "/lraVawavIXh5geMlVjpzCw9TGwR.jpg",
                production_companies: [
                    Preview_company(id:5975,logo_path:"/vvjgoKygWWYZvYyidT3RmOCq5If.png",name:"YLE", origin_country:"FI"),
                    Preview_company(id:76,logo_path:"/nebkQYtQKhZyHJfh5v0oGpNbPzu.png",name:"Zentropa Entertainments", origin_country:"DK")
                ],
                production_countries: [
                    Preview_country(iso_3166_1:"DK", name:"Denmark"),
                    Preview_country(iso_3166_1:"FR", name:"France"),
                    Preview_country(iso_3166_1:"DE", name:"Germany"),
                    Preview_country(iso_3166_1:"NL", name:"Netherlands")
                ],
                original_title: "hi",
                release_date: "2019-06-17",
                spoken_languages: [
                    Preview_language(english_name: "English", iso_639_1: "en", name: "English")
                ],
                status: "Released",
                title: "Dogville", runtime: 178, vote_average: 7.784
            ),
            cast: Preview_cast_crew(
                cast: [
                    Preview_people(
                        id: 2227,
                        department:"nil",
                        job:"nil",
                        original_name: "Nicole Kidman",
                        profile_path:"/m56BJJsW3uynaZDwtFCFeoDgH5o.jpg",
                        character: "Grace Margaret Mulligan",
                        known_for_department: "Acting"
                    ),
                    Preview_people(
                        id: 7569,
                        department:"nil",
                        job:"nil",
                        original_name: "Harriet Andersson",
                        profile_path:"/rFQNqEAyzAw5XAMeVPFZlcveNgF.jpg",
                        character: "Gloria",
                        known_for_department: "Acting"
                    ),
                    Preview_people(
                        id: 7570,
                        department:"nil",
                        job:"nil",
                        original_name: "Lauren Bacall",
                        profile_path:"/lpzzFF8cDAE9Lm5THFlUbDATaOn.jpg",
                        character: "Ma Ginger",
                        known_for_department: "Acting"
                    ),

                ],
                crew: [
                    Preview_people(
                        id: 42,
                        department: "Writing",
                        job: "Screenplay",
                        original_name: "Lars von Trier",
                        profile_path: "/vyLqx52Fj5E5wN6gqJtqOyWIfa6.jpg",
                        character:nil,
                        known_for_department: "Directing"
                    ),
                    Preview_people(
                        id: 42,
                        department: "Writing",
                        job: "Director",
                        original_name: "Lars von Trier",
                        profile_path: "/vyLqx52Fj5E5wN6gqJtqOyWIfa6.jpg",
                        character:nil,
                        known_for_department: "Directing"
                    ),
                    Preview_people(
                        id: 42,
                        department: "Writing",
                        job: "Director",
                        original_name: "Lars von Trier2",
                        profile_path: "/vyLqx52Fj5E5wN6gqJtqOyWIfa6.jpg",
                        character:nil,
                        known_for_department: "Directing"
                    ),
                    Preview_people(
                        id: 42,
                        department: "Writing",
                        job: "Director",
                        original_name: "Lar von Trier3",
                        profile_path: "/vyLqx52Fj5E5wN6gqJtqOyWIfa6.jpg",
                        character:nil,
                        known_for_department: "Directing"
                    )
                ]
            ),
            source: "search"
        )
    }
}

