//
//  StudySession.swift
//  GoStudy
//
//  Created by Phillip Bilenko on 2/18/26.
//

import Foundation

struct StudySession: Identifiable, Codable{
    let id = UUID()
    let startTime: Date
    var endTime: Date?
    var cardsStudied: Int
}
