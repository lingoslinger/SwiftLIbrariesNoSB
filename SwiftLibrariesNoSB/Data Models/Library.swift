//
//	LibraryList.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 7/21/16.
//  Copyright © 2016 - 2021 Allan Evans. All rights reserved.

import Foundation

struct Library : Codable {
	let address : String?
	let city : String?
	let hoursOfOperation : String?
	let location : Location?
	let name : String?
	let phone : String?
	let state : String?
	let website : Website?
	let zip : String?

	enum CodingKeys: String, CodingKey {
		case address = "address"
		case city = "city"
		case hoursOfOperation = "hours_of_operation"
		case location = "location"
		case name = "name_"
		case phone = "phone"
		case state = "state"
		case website = "website"
		case zip = "zip"
	}
    
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		hoursOfOperation = try values.decodeIfPresent(String.self, forKey: .hoursOfOperation)
		location = try values.decodeIfPresent(Location.self, forKey: .location)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		state = try values.decodeIfPresent(String.self, forKey: .state)
        website = try values.decodeIfPresent(Website.self, forKey: .website)
		zip = try values.decodeIfPresent(String.self, forKey: .zip)
    }
}
