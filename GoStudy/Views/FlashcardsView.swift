//
//  FlashcardsView.swift
//  GoStudy
//
//  Created by Phillip Bilenko on 2/9/26.
//

import SwiftUI

let sampleFlashcards = [
    Flashcard(question: "What is 2 + 2?", answer: "4"),
    Flashcard(question: "Capital of France", answer: "paris"),
    Flashcard(question: "What language is this app written in", answer: "Swift")
]

struct FlashcardsView: View {
    var body: some View {
        List(sampleFlashcards) {card in
            FlashcardRow(flashcard: card)
                .listRowSeparator(.hidden)
                .padding(.vertical,4)
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Flashcards")
    }
}

#Preview {
    FlashcardsView()
}
