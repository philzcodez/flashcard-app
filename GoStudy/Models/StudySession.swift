//
//  StudySession.swift
//  GoStudy
//
//  Created by Phillip Bilenko on 2/18/26.
//

import Foundation

struct StudySession: Identifiable, Codable, Equatable{
    let id: UUID
    let startTime: Date
    var endTime: Date
    var cardsStudied: Int
    
    init(id: UUID = UUID(), startTime: Date, endTime: Date, cardsStudied: Int) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.cardsStudied = cardsStudied
    }
}
