//
//  FlashcardRow.swift
//  GoStudy
//
//  Created by Phillip Bilenko on 2/12/26.
//

import SwiftUI

struct FlashcardRow: View {
    let flashcard: Flashcard
    @State private var showAnswer = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(showAnswer ? flashcard.answer: flashcard.question)
                .font(.headline)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
            
            Text("Tap to flip")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(10)
        .shadow(radius: 1, x:0, y:1)
        .onTapGesture {
            withAnimation(.spring()) {
                showAnswer.toggle()
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(showAnswer ? "Answer: \(flashcard.answer)" : "Question: \(flashcard.question)")
        .accessibilityHint("Tap to flip between question and answer")
    }
}

