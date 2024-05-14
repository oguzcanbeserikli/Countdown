//
//  Reminder.swift
//  Countdown
//
//  Created by Oğuzcan Beşerikli on 4.05.2024.
//

import Foundation
import UIKit

struct Reminder: Identifiable, Codable{
    let id: String
    let title: String
    let memoryText: String?
    let date: Date
    
    init(id: String, title: String, memoryText: String? = nil, date: Date) {
        self.id = id
        self.title = title
        self.memoryText = memoryText
        self.date = date
    }
}

struct PersistentManager {
    static let shared = PersistentManager()
    
    func saveData(data: [Reminder]) {
        do {
            let data = try JSONEncoder().encode(data)
            UserDefaults.standard.setValue(data, forKey: "data")
        }
        catch{
            print("Error encoding data: \(error)")
        }
    }
    
    func readData() -> [Reminder] {
        do{
            if let savedData = UserDefaults.standard.data(forKey: "data") {
                return try JSONDecoder().decode([Reminder].self, from: savedData)
            }
        }
        catch{
            print("Error decoding data: \(error)")
            return []
        }
        return []
    }
}

