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
    var film_data: Film_rating?
    var recs: [Film_recs]?
    @State private var showLibraryStatusAlert = true
    
    var body: some View {
        ScrollView {
                TitlePreview(film: film, cast: cast)
                    .frame(height:450)
            VStack (alignment: .leading) {
//                if film_data?.libraryStatus == 0 && showLibraryStatusAlert {
//                    HStack{
//                        Spacer()
//                            .frame(width: .infinity)
//                        LibraryStatusAlert(film: film, isPresented: $showLibraryStatusAlert)
//                        Spacer()
//                            .frame(width: .infinity)
//                    }
//                }
//
//                URLButtons(film: film)
//
//                if let filmData = film_data {
//                    FilmReview(film_data: filmData)
//                }
//                
//                SynopsisPreview(film: film)
//                Spacer()
//                    .frame(height:20)
//                CastPreview(cast: cast)
//                Divider()
                //                    AwardsPreview()
                //                    Divider()
                if recs != nil {
                    RecommendationPreview(list: recs!)
                }
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
                    
                    Spacer()
                        .frame(height:5)
                    
                    Text(dateString)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(UIColor.systemGray4))
                    
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

struct LibraryStatusAlert: View {
    var film: Preview_film
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .frame(width: 25, height: 25)
                }
                .padding(.leading, 290)
                .padding(.bottom, 60)
                .padding(.trailing, 8)
            }
            
            VStack {
                Text("Have you watched this film?")
                    .font(.headline)
                HStack {
                    Button("Yes") {
                        Task {
                            await updateRating(field: "libraryStatus", value: 1, movieId: film.id)
                            isPresented = false
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    Button("Not Yet") {
                        isPresented = false
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .frame(width: 300, height: 130)
    }
    
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
}

struct URLButtons: View {
    var film: Preview_film
    var letterboxdId: String {
        return film.title.lowercased().replacingOccurrences(of: " ", with: "-")
    }
    
    var body: some View {
        HStack {
            Spacer()
            // IMDB
            if let imdbId = film.imdb_id as String?, !imdbId.isEmpty {
                if let url = URL(string: "https://www.imdb.com/title/\(imdbId)") {
                    Link(destination: url) {
                        Image("logo_imdb")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                    }
                }
            }
            Spacer()
                .frame(width: 20)
            // LETTERBOXD
            if let url = URL(string: "https://letterboxd.com/film/\(letterboxdId)") {
                Link(destination: url) {
                    HStack {
                        Image("logo_letterboxd")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
                }
            }
            Spacer()
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

struct FilmReview: View {
    var film_data: Film_rating
    @State private var cinematographyRating: Float = 0
    @State private var editingRating: Float = 0
    @State private var costumeMakeupRating: Float = 0
    @State private var lightingRating: Float = 0
    @State private var stagingRating: Float = 0
    @State private var settingPropsRating: Float = 0
    @State private var narrativeRating: Float = 0
    @State private var narrativeComment: String = ""
    
    // Debouncing states
    @State private var lastUpdateTime: Date = Date()
    @State private var pendingUpdate: (String, Float)? = nil
    @State private var pendingWorkItem: DispatchWorkItem? = nil
    let debounceInterval: TimeInterval = 0.2
    
    init(film_data: Film_rating) {
        self.film_data = film_data
        _cinematographyRating = State(initialValue: film_data.cinematography)
        _editingRating = State(initialValue: film_data.editing)
        _costumeMakeupRating = State(initialValue: film_data.costume_makeup)
        _lightingRating = State(initialValue: film_data.lighting)
        _stagingRating = State(initialValue: film_data.staging)
        _settingPropsRating = State(initialValue: film_data.setting_props)
        _narrativeRating = State(initialValue: film_data.narrativeRating)
        _narrativeComment = State(initialValue: film_data.narrativeComment)
    }
    
    func handleRatingUpdate(field: String, value: Float) {
        // Cancel any pending work
        pendingWorkItem?.cancel()
        
        // Create new work item
        let workItem = DispatchWorkItem {
            Task {
                await self.updateRating(field: field, value: value, movieId: self.film_data.id)
            }
            self.pendingUpdate = nil
            self.lastUpdateTime = Date()
        }
        
        // Store the work item
        pendingWorkItem = workItem
        
        // Schedule the update
        DispatchQueue.main.asyncAfter(deadline: .now() + debounceInterval, execute: workItem)
    }
    
    func updateRating(field: String, value: Float, movieId: Int) async {
        do {
            print("UPDATE \(field) with \(value)")
            let updateData: [String: Float] = [field: value]
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
                .font(.headline)
                .foregroundColor(.black)
                .fontWeight(.bold)
                .padding(EdgeInsets(top:5, leading: 0, bottom: 5, trailing: 0))
            
            RatingRow(title: "Cinematography", rating: $cinematographyRating) { newRating in
                handleRatingUpdate(field: "cinematography", value: newRating)
            }
            
            RatingRow(title: "Editing", rating: $editingRating) { newRating in
                handleRatingUpdate(field: "editing", value: newRating)
            }
            
            RatingRow(title: "Costume / Makeup", rating: $costumeMakeupRating) { newRating in
                handleRatingUpdate(field: "costume_makeup", value: newRating)
            }
            
            RatingRow(title: "Lighting", rating: $lightingRating) { newRating in
                handleRatingUpdate(field: "lighting", value: newRating)
            }
            
            RatingRow(title: "Staging", rating: $stagingRating) { newRating in
                handleRatingUpdate(field: "staging", value: newRating)
            }
            
            RatingRow(title: "Setting / Props", rating: $settingPropsRating) { newRating in
                handleRatingUpdate(field: "setting_props", value: newRating)
            }
            
            RatingRow(title: "Narrative", rating: $narrativeRating) { newRating in
                handleRatingUpdate(field: "narrativeRating", value: newRating)
            }
            
            Spacer()
                .frame(height: 20)
            
            TextEditor(text: $narrativeComment)
                .frame(height: 100)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                .onChange(of: narrativeComment) { newValue in
                    Task {
                        await updateNote(field: "narrativeComment", value: newValue, movieId: film_data.id)
                    }
                }
        }
    }
}

struct RatingRow: View {
    let title: String
    @Binding var rating: Float
    let onRatingChanged: (Float) -> Void
    @State private var ratingText: String = ""
    
    let maxRating = 5
    let starSize: CGFloat = 24
    let starSpacing: CGFloat = 4

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)

            let totalStarRowWidth = CGFloat(maxRating) * starSize + CGFloat(maxRating - 1) * starSpacing

            HStack(spacing: 8) {
                GeometryReader { geo in
                    ZStack {
                        HStack(spacing: starSpacing) {
                            ForEach(0..<maxRating, id: \.self) { i in
                                let current = Float(i)
                                ZStack {
                                    Image(systemName: "star")
                                        .resizable()
                                        .frame(width: starSize, height: starSize)
                                        .foregroundColor(.gray)

                                    if rating >= current + 1 {
                                        Image(systemName: "star.fill")
                                            .resizable()
                                            .frame(width: starSize, height: starSize)
                                            .foregroundColor(.yellow)
                                    } else if rating > current {
                                        let fill = CGFloat(rating - current)
                                        Image(systemName: "star.fill")
                                            .resizable()
                                            .frame(width: starSize, height: starSize)
                                            .foregroundColor(.yellow)
                                            .mask(
                                                Rectangle()
                                                    .size(width: starSize * fill, height: starSize)
                                            )
                                    }
                                }
                            }
                        }
                        .frame(width: totalStarRowWidth, alignment: .leading)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let location = value.location.x
                                    let clamped = min(max(location, 0), totalStarRowWidth)
                                    let newRating = Float(clamped / totalStarRowWidth) * Float(maxRating)
                                    withAnimation(.easeInOut(duration: 0.15)) {
                                        rating = newRating
                                        ratingText = String(format: "%.1f", rating)
                                        onRatingChanged(newRating)
                                    }
                                }
                        )
                    }
                    .frame(height: starSize)
                }
                .frame(width: totalStarRowWidth)

                // Group TextField and Clear Button with tight spacing
                HStack(spacing: 4) {
                    TextField("", text: $ratingText)
                        .keyboardType(.decimalPad)
                        .frame(width: 50)
                        .onChange(of: ratingText) { newValue in
                            if let newRating = Float(newValue), newRating >= 0, newRating <= 5 {
                                withAnimation {
                                    rating = newRating
                                    onRatingChanged(rating)
                                }
                            }
                        }
                        .onAppear {
                            ratingText = String(format: "%.1f", rating)
                        }

                    if rating > 0 {
                        Button(action: {
                            withAnimation {
                                rating = 0
                                ratingText = "0.0"
                                onRatingChanged(0)
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 1)
    }
}

struct RecommendationPreview: View {
    var list: [Film_recs] = []
    var f = 1.8
    @State private var isSheetActive = false
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(list, id: \.id) { movie in
                    Button(action: {
                        //                        isSheetActive = true
                        //                        MovieDetails(movie.id)
                    }, label: {
                        RecBlock(film: movie)
                            .frame(width: CGFloat(160*f), height: CGFloat(90*f))
                    })
                }
            }
        }
    }
}

// preview
struct FilmDetailPage_Previews: PreviewProvider {
    static let similar = [
        Film_recs(
            id: 16,
            title: "Dancer in the Dark",
            original_title: "Dancer in the Dark",
            overview: "Selma, a Czech immigrant on the verge of blindness, struggles to make ends meet for herself and her son, who has inherited the same genetic disorder and will suffer the same fate without an expensive operation. When life gets too difficult, Selma learns to cope through her love of musicals, escaping life's troubles – even if just for a moment – by dreaming up little numbers to the rhythmic beats of her surroundings.",
            poster_path: "/9rsivF4sWfmBzrNr4LPu6TNJhXX.jpg",
            backdrop_path: "/uBxuQLYMArjzSNCyPk9icn7if7s.jpg",
            release_date: "2000-09-01"
        ),
        Film_recs(
            id: 1951,
            title: "Manderlay",
            original_title: "Manderlay",
            overview: "In 1933, after leaving Dogville, Grace Margaret Mulligan sees a slave being punished at a cotton farm called Manderlay. Officially, slavery is illegal and Grace stands up against the farmers. She stays with some gangsters in Manderlay and tries to influence the situation. But when harvest time comes, Grace sees the social and economic reality of Manderlay.",
            poster_path: "/6HYoHEcLNgETHlJDyQrC4Y7e01.jpg",
            backdrop_path: "/dbAAQhptC6FyxBJx91IQv9zRiki.jpg",
            release_date: "2005-06-03"
        ),
        Film_recs(
            id: 145,
            title: "Breaking the Waves",
            original_title: "Breaking the Waves",
            overview: "In a small and conservative Scottish village, a woman's paralytic husband convinces her to have extramarital intercourse so she can tell him about it and give him a reason for living.",
            poster_path: "/dQWMcdHXUOSHtr7ypOCa5T79JMS.jpg",
            backdrop_path: "/nY2faCdUVHzuH6FmDI6QsAURE68.jpg",
            release_date: "1996-07-05"
        )
    ]

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
            source: "library",
            film_data: Film_rating(
                id: 553,
                cinematography: 4.1,
                editing: 3.5,
                costume_makeup: 0.0,
                lighting: 0.0,
                staging: 0.0,
                setting_props: 0.0,
                narrativeRating: 0.0,
                narrativeComment: "",
                libraryStatus: 0,
                whyWatch: ""
            ),
            recs: similar
        )
    }
}
