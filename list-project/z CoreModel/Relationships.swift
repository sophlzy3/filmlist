//
//  Relationship_Company+CoreDataClass.swift
//  list-project
//
//  Created by Sophie Liu on 2023-09-14.
//
//

/*
import Foundation
import CoreData

@objc(Relationship_Company)
public class Relationship_Company: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Relationship_Company> {
        return NSFetchRequest<Relationship_Company>(entityName: "Relationship_Company")
    }
    
    @NSManaged public var relCompany_company: Detail_Company?
    @NSManaged public var relCompany_film: Detail_Film?
    
}

public class Relationship_Country: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Relationship_Country> {
        return NSFetchRequest<Relationship_Country>(entityName: "Relationship_Country")
    }

    @NSManaged public var relCountry_country: Detail_Country?
    @NSManaged public var relCountry_film: Detail_Film?

}

@objc(Relationship_Genre)
public class Relationship_Genre: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Relationship_Genre> {
        return NSFetchRequest<Relationship_Genre>(entityName: "Relationship_Genre")
    }

    @NSManaged public var genre_id: Int64
    @NSManaged public var movie_id: Int64
    @NSManaged public var relGenre_film: Detail_Film?
    @NSManaged public var relGenre_genre: Detail_Genre?

}

@objc(Relationship_Language)
public class Relationship_Language: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Relationship_Language> {
        return NSFetchRequest<Relationship_Language>(entityName: "Relationship_Language")
    }

    @NSManaged public var relLang_film: Detail_Film?
    @NSManaged public var relLang_lang: Detail_Language?

}

@objc(Relationship_List)
public class Relationship_List: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Relationship_List> {
        return NSFetchRequest<Relationship_List>(entityName: "Relationship_List")
    }

    @NSManaged public var relList_film: Detail_Film?
    @NSManaged public var relList_list: List_film?

}

@objc(Relationship_Rating)
public class Relationship_Rating: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Relationship_Rating> {
        return NSFetchRequest<Relationship_Rating>(entityName: "Relationship_Rating")
    }
    
    @NSManaged public var relRating_film: Detail_Film?
    @NSManaged public var relRating_rating: Detail_Rating?
}

@objc(Relationship_Crew)
public class Relationship_Crew: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Relationship_Crew> {
        return NSFetchRequest<Relationship_Crew>(entityName: "Relationship_Crew")
    }
    
    @NSManaged public var movie_id: Int64
    @NSManaged public var movie_name: String?
    @NSManaged public var person_id: Int64
    @NSManaged public var person_name: String?
    @NSManaged public var relCrew_crew: Page_Crew?
    @NSManaged public var relCrew_film: Detail_Film?
    
}

*/
