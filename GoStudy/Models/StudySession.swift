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
    
    var durationSeconds: Int {
        Int(endTime.timeIntervalSince(startTime))
    }
    
    var durationString: String {
        let minutes = durationSeconds / 60
        let seconds = durationSeconds % 60
        return minutes > 0
            ? "\(minutes)m \(seconds)s"
            : "\(seconds)s"
    }
    
    init(id: UUID = UUID(), startTime: Date, endTime: Date, cardsStudied: Int) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.cardsStudied = cardsStudied
    }
}
