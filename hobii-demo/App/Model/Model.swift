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
    var baseCharge: Int = 500
    
    init(name: String){
        self.name = name
    }
}


public struct Project: Codable {
    
    var name: String
    var hours: Int
    var minutes: Int
    var isArchived: Bool
    var isRunning: Bool
    var creationDate: Date
    var playDate: Date?
    var pauseDate: Date?
    var invoicedHours: Double
    
    init(name: String, creationDate: Date){
        self.name = name
        self.hours = 0
        self.minutes = 0
        self.invoicedHours = 0.0
        self.isArchived = false
        self.isRunning = false
        self.creationDate = creationDate
    }
    
    mutating func calculateHours(){
        let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: playDate ?? Date(), to: pauseDate ?? Date())
        self.hours += diffComponents.hour ?? 0
        
        
        if self.minutes + (diffComponents.minute ?? 0)  >= 60{
            self.hours += 1
            self.minutes = self.minutes + (diffComponents.minute ?? 0) - 60
        }else{
            self.minutes += diffComponents.minute ?? 0
        }
        
    }
    
    func canMakeInvoice() -> Bool{
        if self.invoicedHours < (Double(self.hours) + Double(self.minutes)/60) {
            return true
        }else{
            return false
        }
    }
    
    func calculatePrice(rate: Int) -> Double {
        let unpaidHours = Double(self.hours) + Double(self.minutes)/60
        
        return unpaidHours * Double(rate)
    }
}
