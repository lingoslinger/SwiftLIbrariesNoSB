//
//	Website.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 7/21/16.
//  Copyright © 2016 - 2021 Allan Evans. All rights reserved.

import Foundation

struct Website : Codable {

	let url : String?
    
	enum CodingKeys: String, CodingKey {
		case url = "url"
	}
    
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		url = try values.decodeIfPresent(String.self, forKey: .url)
	}
}
