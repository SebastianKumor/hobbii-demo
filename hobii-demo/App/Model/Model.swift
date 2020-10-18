//
//  Model.swift
//  hobii-demo
//
//  Created by Sebastian Kumor on 18/10/2020.
//

import Foundation


public struct User: Codable {
    var name: String
    var projects: [Project]?
    
    init(name: String){
        self.name = name
    }
}


public struct Project: Codable {
    
    var name: String
    var hours: Double
    var isArchived: Bool
    var creationDate: Date
    var playDate: Date?
    var pauseDate: Date?
    
    init(name: String, creationDate: Date){
        self.name = name
        self.hours = 0.0
        self.isArchived = false
        self.creationDate = creationDate
    }
}
