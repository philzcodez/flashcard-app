//
//  Flashcard.swift
//  GoStudy
//
//  Created by Phillip Bilenko on 2/10/26.
//

import Foundation

struct Flashcard: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}
