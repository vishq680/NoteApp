//
//  User.swift
//  WeeklyAssignment7
//
//  Created by Vishaq Jayakumar on 3/17/24.
//

import Foundation

//MARK: struct for a user...
struct User: Codable{
    var name:String
    var email:String
    var password:String
    
    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
}
