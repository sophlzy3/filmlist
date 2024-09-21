//
//  FilmDetail+CoreDataClass.swift
//  list-project
//
//  Created by Sophie Liu on 2023-08-09.
//
//


import Foundation
import CoreData

// Assuming you have set up your Core Data stack somewhere in your application
let persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "YourModelName")
    container.loadPersistentStores(completionHandler: { (_, error) in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}()

// Get the managed object context from the persistent container
let yourManagedObjectContext = persistentContainer.viewContext


//already hashable, equatable
public class Detail_Film: NSManagedObject, Codable {
    @NSManaged public var backdrop_path: String?
    @NSManaged public var movie_id: Int64
    @NSManaged public var imdb_id: String?
    @NSManaged public var original_title: String?
    @NSManaged public var overview: String?
    @NSManaged public var poster_path: String?
    @NSManaged public var release_date: String?
    @NSManaged public var runtime: Int64
    //@NSManaged public var screenwriter: String?
    @NSManaged public var status: String?
    @NSManaged public var title: String
    @NSManaged public var film_relCrew: Relationship_Crew?
    @NSManaged public var film_relCompany: Relationship_Company?
    @NSManaged public var film_rel_Country: Relationship_Country?
    @NSManaged public var film_rel_Genre: Relationship_Genre?
    @NSManaged public var film_rel_Language: Relationship_Language?
    @NSManaged public var film_relRating: Relationship_Rating?
    @NSManaged public var film_relList: Relationship_List?

    private enum CodingKeys: String, CodingKey {
        case backdrop_path
//        case director 
        case id
        case imdb_id
        case original_title
        case overview
        case poster_path
        case release_date
        case runtime
        case status
        case title
        case film_relActor
        case film_relAward
        case film_relCompany
        case film_rel_Country
        case film_rel_Genre
        case film_rel_Language
        case film_relRating
        case film_relList
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let contextKey = CodingUserInfoKey(rawValue: "managedObjectContext"),
              let context = decoder.userInfo[contextKey] as? NSManagedObjectContext else {
            fatalError("Context missing")
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "FilmDetail", in: context)!
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let backdropPath = try container.decodeIfPresent(String.self, forKey: .backdrop_path) { backdrop_path = backdropPath }
        if let idValue = try container.decodeIfPresent(Int64.self, forKey: .id) { movie_id = idValue }
        if let imdbIdValue = try container.decodeIfPresent(String.self, forKey: .imdb_id) { imdb_id = imdbIdValue }
        if let originalTitleValue = try container.decodeIfPresent(String.self, forKey: .original_title) { original_title = originalTitleValue }
        if let overviewValue = try container.decodeIfPresent(String.self, forKey: .overview) { overview = overviewValue }
        if let posterPath = try container.decodeIfPresent(String.self, forKey: .poster_path) { poster_path = posterPath }
        if let releaseDateValue = try container.decodeIfPresent(String.self, forKey: .release_date) { release_date = releaseDateValue }
        if let runtimeValue = try container.decodeIfPresent(Int64.self, forKey: .runtime) { runtime = runtimeValue }
        if let statusValue = try container.decodeIfPresent(String.self, forKey: .status) { status = statusValue }
        if let titleValue = try container.decodeIfPresent(String.self, forKey: .title) { title = titleValue }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(backdrop_path, forKey: .backdrop_path)
        try container.encode(movie_id, forKey: .id)
        try container.encode(imdb_id, forKey: .imdb_id)
        try container.encode(original_title, forKey: .original_title)
        try container.encode(overview, forKey: .overview)
        try container.encode(poster_path, forKey: .poster_path)
        try container.encode(release_date, forKey: .release_date)
        try container.encode(runtime, forKey: .runtime)
        try container.encode(status, forKey: .status)
        try container.encode(title, forKey: .title)
    }
}

extension Detail_Film {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Detail_Film> {
        return NSFetchRequest<Detail_Film>(entityName: "Detail_Film")
    }
}


extension Detail_Film : Identifiable {
}

