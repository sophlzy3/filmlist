//
//  LibraryMain.swift
//  list-project
//
//  Created by Sophie Liu on 2023-07-20.
//

import SwiftUI

struct LibraryMain: View {
    var body: some View {
        ScrollView {
            NavigationStack {
                List{
                    NavigationLink("Titles") {
                        //FolderDetail(id: workFolder.id)
                    }
                }
            }
            .toolbar {
                Text("toolbar if u need")
                Image(systemName: "plus.circle.fill")
            }
        }
    }
}

struct Titles: View {
    var body: some View {
        Text("titles page")
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        LibraryMain()
    }
}
