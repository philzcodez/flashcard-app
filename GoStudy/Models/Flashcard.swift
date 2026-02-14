//
//  Flashcard.swift
//  GoStudy
//
//  Created by Phillip Bilenko on 2/10/26.
//

import Foundation

struct Flashcard: Identifiable, Codable, Equatable {
    let id: UUID
    let question: String
    let answer: String
}

let sampleFlashcards: [Flashcard] = [
    Flashcard(id: UUID(), question: "What is 2 + 2?", answer: "4"),
    Flashcard(id: UUID(), question: "Capital of France?", answer: "Paris"),
    Flashcard(id: UUID(), question: "What is SwiftUI?", answer: "Apple's UI framework")
]
