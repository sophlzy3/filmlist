//
//  CastAndCrew.swift
//  list-project
//
//  Created by Sophie Liu on 2023-07-05.
//

import SwiftUI

struct PeoplePage: View {
    var person: Preview_people
    
    init(person: Preview_people) {
        self.person = person
    }
    
    var body: some View {
        Text("Hello, World!")
    }
}


struct CastAndCrew: View {
    var body: some View {
        Text("Hello, World!")
    }
}

struct CastAndCrew_Previews: PreviewProvider {
    static var previews: some View {
        CastAndCrew()
    }
}
