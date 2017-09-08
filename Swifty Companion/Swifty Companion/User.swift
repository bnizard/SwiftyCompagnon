//
//  User.swift
//  Swifty Companion
//
//  Created by Bastien NIZARD on 6/15/17.
//  Copyright © 2017 Bastien NIZARD. All rights reserved.
//

import Foundation

class User : NSObject {
        public var imageUrl: String?
        public var location: String?
        public var login: String?
        public var email: String?
        public var niveau: Double?
        public var projets: NSArray?
        public var skills: NSArray?
        
        override init()
        {
            imageUrl = nil
            location = nil
            login = nil
            email = nil
            niveau = 0
            projets = nil
            skills = nil
        }
    
        public func refresh()
        {
            imageUrl = nil
            location = nil
            login = nil
            email = nil
            niveau = 0
            projets = nil
            skills = nil
        }
}
