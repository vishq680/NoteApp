//
//  UserProfile.swift
//  WeeklyAssignment7
//
//  Created by Vishaq Jayakumar on 3/20/24.
//

import Foundation

struct UserProfile: Decodable {
    let id: String
    let name: String
    let email: String
    let version: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case email
        case version = "__v"
    }
}
