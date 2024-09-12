//
//  ListEditPage.swift
//  list-project
//
//  Created by Sophie Liu on 2024-07-23.
//

import SwiftUI

struct ListEditPage: View {
    var imageSize: CGFloat = 60
    var list: [Data_list]
    var connection: [Rel_movie_list]
    var movieID: Int
    var types: [String] {
        let types = list.map { $0.type }
        return Array(Set(types)).sorted()
    }

    var body: some View {
        ScrollView {            
            ForEach(list) { listObject in
                RowListDetails(list: listObject, connection: connection, movieID: movieID)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(5)
            }
        }
    }
}

struct RowListDetails: View {
    var movieID: Int
    var list: Data_list
    var connection: [Rel_movie_list]
//    var imageHeight: CGFloat = 60

    let connect: Rel_movie_list?
    @State private var imageSize: CGFloat = 60
    @State private var textFieldContent: String = ""
    @State private var isChecked: Bool = false
    @FocusState private var isTextFieldFocused: Bool
    @State private var showAlert = false

    init(list: Data_list, connection: [Rel_movie_list], movieID: Int) {
        self.list = list
        self.connection = connection
        self.movieID = movieID
        self.connect = connection.first(where: { $0.list_id == list.id })
        
        if let connect = self.connect {
            _isChecked = State(initialValue: true)
            _textFieldContent = State(initialValue: connect.note)
        }
    }
    
    var body: some View {
        HStack (alignment: .center) {
            // List Cover
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
            
            VStack(alignment: .leading) {
                // Checkmark Button
                Button(action: {
                    
                    if isChecked {
                        performCheckedAction()
                    } else {
                        performUncheckedAction()
                    }
                }, label: {
                    HStack (alignment: .bottom) {
                        Text(list.name)
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Text(list.type)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    if isChecked {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.gray)
                            .frame(width: 20, height: 20)
                    } else {
                        Image(systemName: "circle")
                            .foregroundColor(.gray)
                            .frame(width: 20, height: 20)
                    }
                })
                     
                TextField(connect?.note ?? "Click to add note", text: $textFieldContent)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: .infinity)
                    .focused($isTextFieldFocused)
                    .onAppear {
                        if let note = connect?.note {
                            textFieldContent = note
                        }
                    }
                    .onChange(of: textFieldContent) { newContent in
                        let listID = connect?.list_id ?? list.id
                        let movieID = connect?.movie_id ?? movieID
                        isChecked = true
                        upsertNote(note: newContent, list_id: listID, movie_id: movieID)
                    }
            }
            .padding()
            .alert("Remove from list?", isPresented: $showAlert) {
                Button("No", role: .cancel) { }
                Button("Yes", role: .destructive) { }
            } message: {
                Text("This is an alert message.")
            }
        }
    }
    
    func upsertNote(note: String, list_id: Int, movie_id: Int) {
        Task {
            do {
                try await SupabaseActions().upsertMovieNote(note: note, listID: list_id, movieID: movie_id)
            } catch {
                print(error)
            }
        }
    }
    
    func performCheckedAction() {
        showAlert = true
        isChecked = false
        print("Checked action performed")
    }
    
    func performUncheckedAction() {
        isTextFieldFocused = true
        isChecked = true
        print("Unchecked action performed")
    }
    
    
}

struct ListEditPage_Previews: PreviewProvider {
    static var previews: some View {
        let dummyList = [
            Data_list(id: 1, name: "To-Watch", type: "aaa", cover: "https://cdn.britannica.com/39/116039-050-9FEAC4FA/reconstruction-ruins-Ishtar-Gate-Babylon-Al-Hillah-Iraq.jpg", imgs: [
                "/vINgGecnz95iDL6fjQMARDsocgG.jpg",
                "/sNACthNvOoSTJxo240N5sqa67ip.jpg"
              ]),
            Data_list(id: 2, name: "metropolis", type: "To-Watch", cover: "https://m.media-amazon.com/images/M/MV5BNDM1MjkwMTgzNV5BMl5BanBnXkFtZTgwNzc4ODUxMzE@._V1_.jpg", imgs: [
                "/vINgGecnz95iDL6fjQMARDsocgG.jpg",
                "/sNACthNvOoSTJxo240N5sqa67ip.jpg"
              ]),
            Data_list(id: 3, name: "gaga", type: "ppppfff", cover: "https://wwd.com/wp-content/uploads/2023/06/MEGA989664_002.jpg?crop=0px%2C404px%2C3600px%2C2015px&resize=1000%2C563", imgs: ["/vINgGecnz95iDL6fjQMARDsocgG.jpg"])
        ]
        let dummyConnection = [
            Rel_movie_list(movie_id: 136, list_id: 1, note: "ahaha"),
            Rel_movie_list(movie_id: 136, list_id: 2, note: "this is metropolis"),
//            Rel_movie_list(movie_id: 102, list_id: 3, note: "hahahhagagagga"),
        ]
        
        ListEditPage(list: dummyList, connection: dummyConnection, movieID: 136)
    }
}
