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
            VStack(alignment: .leading, spacing: 4) {
                Text(card.question)
                    .font(.headline)
                Text(card.answer)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(4)
            
        }
        .navigationTitle(Text("Flashcards"))
    }
}

#Preview {
    FlashcardsView()
}
