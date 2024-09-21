//
//  Detail_Genre+CoreDataClass.swift
//  list-project
//
//  Created by Sophie Liu on 2023-09-14.
//
//

/*
import Foundation
import CoreData

@objc(Detail_Genre)
public class Detail_Genre: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Detail_Genre> {
        return NSFetchRequest<Detail_Genre>(entityName: "Detail_Genre")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var genreToFilm: Relationship_Genre?

}

@objc(Detail_Country)
public class Detail_Country: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Detail_Country> {
        return NSFetchRequest<Detail_Country>(entityName: "Detail_Country")
    }

    @NSManaged public var iso_3166_1: String?
    @NSManaged public var name: String?
    @NSManaged public var country_relCountry: Relationship_Country?
}

@objc(Detail_Crew)
public class Detail_Crew: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Page_Crew> {
        return NSFetchRequest<Page_Crew>(entityName: "Page_Crew")
    }

    @NSManaged public var crew_relCrew: Relationship_Crew?
}

@objc(Detail_Company)
public class Detail_Company: NSManagedObject {
    extension Detail_Company {

        @nonobjc public class func fetchRequest() -> NSFetchRequest<Detail_Company> {
            return NSFetchRequest<Detail_Company>(entityName: "Detail_Company")
        }

        @NSManaged public var id: Int64
        @NSManaged public var logo_path: String?
        @NSManaged public var name: String?
        @NSManaged public var origin_country: String?
        @NSManaged public var company_relCompany: Relationship_Company?

    }

}


@objc(Detail_Language)
public class Detail_Language: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Detail_Language> {
        return NSFetchRequest<Detail_Language>(entityName: "Detail_Language")
    }
    
    @NSManaged public var english_name: String?
    @NSManaged public var iso_639_1: String?
    @NSManaged public var name: String?
    @NSManaged public var lang_relLang: Relationship_Language?
    
}

@objc(Detail_Rating)
public class Detail_Rating: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Detail_Rating> {
        return NSFetchRequest<Detail_Rating>(entityName: "Detail_Rating")
    }

    @NSManaged public var rating_relRating: Relationship_Rating?
}

*/
