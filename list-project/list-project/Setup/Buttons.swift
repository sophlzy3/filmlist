//
//  Buttons.swift
//  list-project
//
//  Created by Sophie Liu on 2024-08-08.
//

import SwiftUI

struct IconButton: View {
    var fill: Color
    var icon: String
    
    var body: some View {
        ZStack (alignment: .center){
            Rectangle()
                .fill(fill)
            Image(systemName: icon)
                .foregroundColor(.white)
                .fontWeight(.heavy)
        }
    }
}


struct ButtonRow: View {
    var movie: ReturnedMovie
    
    @State private var rec2width = CGFloat(0)
    @State private var rec3width = CGFloat(0)
    @State private var expanded = false // for drag
    @State private var override = false // for drag
    @State private var maxblockwidth = CGFloat(100)
    
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastType: AlertToast.AlertType = .complete(.green)
    
    @State private var isSheetActive = false
    @State private var listEditList = [Data_list(id: 1, name: "", type: "", cover: "", imgs: [])]
    @State private var listEditConnection = [Rel_movie_list(movie_id: 1, list_id: 1, note: "23")]
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Text("\(listEditList)")
                    .opacity(0.001)
                    .frame(maxWidth: .infinity)
                
                // List edit button
                Button(action: {
                    list_edit(movie)
                }) {
                    IconButton(fill: .orange, icon: "list.bullet")
                        .frame(width: rec2width)
                        .clipped()
                }
                
                // Add to library button
                Button(action: {
                    addMovie(movie: movie)
                }) {
                    IconButton(fill: .pink, icon: "plus")
                        .frame(width: rec3width)
                        .clipped()
                }
            }
            .gesture(drag(film: movie, geometry: geometry))
            .sheet(isPresented: $isSheetActive) {
                ListEditPage(list: listEditList, connection: listEditConnection, movieID: movie.id)
            }
            .toast(isPresenting: $showToast, duration: 1) {
                AlertToast(displayMode: .hud, type: toastType, title: toastMessage)
            }
        }
    }
    
    func addMovie(movie: ReturnedMovie) {
        Task {
            do {
                DispatchQueue.main.async {
                    toastMessage = "Adding movie"
                    showToast = true
                    toastType = .loading
                }
                
                try await SupabaseActions().addMovieDetails(id: movie.id, filmPreview: movie)
                
                DispatchQueue.main.async {
                    toastMessage = "Movie Added"
                    showToast = true
                    toastType = .complete(.green)
                }
            } catch {
                let errorString = String(describing: error)
                if errorString.contains("code: Optional(\"23505\")") {
                    DispatchQueue.main.async {
                        toastMessage = "Movie Already in Library"
                        showToast = true
                        toastType = .error(.red)
                    }
                } else {
                    print(error)
                }
            }
        }
    }
    
    func list_edit(_ film: ReturnedMovie) {
        Task {
            do {
                // Fetch the list and connection data asynchronously
                let (fetchedList, fetchedConnection) = try await SupabaseActions().fetchAllMovieList(movie_id: film.id)
                
                // Update the state variables on the main thread
                DispatchQueue.main.async {
                    self.listEditList = fetchedList
                    self.listEditConnection = fetchedConnection
                    self.isSheetActive = true
                }
            } catch {
                print("Error fetching data: \(error)")
            }
        }
    }
    
    func drag(film: ReturnedMovie, geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation(.easeInOut(duration: 0.3)) {
                    if !expanded {
                        rec2width = -value.translation.width / 2
                        rec3width = -value.translation.width / 2
                        if -value.translation.width >= geometry.size.width * 0.6 {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                rec2width = 0
                                rec3width = geometry.size.width * 0.6
                                override = true
                            }
                        }
                    } else {
                        rec2width = -value.translation.width / 2 + maxblockwidth
                        rec3width = -value.translation.width / 2 + maxblockwidth
                        
                        if (-value.translation.width + 140) >= geometry.size.width * 0.6 {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                rec2width = 0
                                rec3width = geometry.size.width * 0.6
                                override = true
                            }
                        }
                    }
                }
            }
            .onEnded { value in
                if override {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        rec2width = 0
                        rec3width = 0
                        expanded = false
                        override = false
                    }
                    addMovie(movie: film)
                } else {
                    if !expanded {
                        if value.translation.width < -60 {
                            rec2width = maxblockwidth
                            rec3width = maxblockwidth
                            expanded.toggle()
                        } else {
                            rec2width = 0
                            rec3width = 0
                        }
                    } else {
                        if value.translation.width > 0 {
                            rec2width = 0
                            rec3width = 0
                            expanded.toggle()
                        } else {
                            rec2width = maxblockwidth
                            rec3width = maxblockwidth
                        }
                    }
                }
            }
    }
}

struct ButtonRow_Preview: PreviewProvider {
    static var previews: some View {
        let dummyFilm = ReturnedMovie(
            id: 136,
            title: "Portrait of a Lady on Fire",
            backdrop_path: "/foFq1RZWQIgFuCQ0nyYccywjFyX.jpg",
            poster_path: "/2LquGwEhbg3soxSCs9VNyh5VJd9.jpg",
            release_date: "2019-06-17",
            genre_ids: [18, 10749],
            original_language: "fr",
            overview: "On an isolated island in Brittany at the end of the eighteenth century, a female painter is obliged to paint a wedding portrait of a young woman."
        )

        GeometryReader { geometry in
            VStack {
                Text("Hello")
                ButtonRow(movie: dummyFilm)
                    .frame(width: .infinity, height: 500)
                Text("=============")
            }
        }
        .previewLayout(.sizeThatFits)
    }
}



#Preview {
    IconButton(fill: .orange, icon: "list.bullet")
        .frame(width: 100, height: 70)
}
