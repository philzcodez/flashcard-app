//
//  FlashcardRow.swift
//  GoStudy
//
//  Created by Phillip Bilenko on 2/12/26.
//

import SwiftUI

struct FlashcardRow: View {
    let flashcard: Flashcard
    @Binding var isFlipped: Bool
    
    var body: some View {
        ZStack{
            // FRONT
            VStack(alignment: .leading, spacing: 6) {
                Text(flashcard.question)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                Text("Tap to reveal")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: 250)
            .background(.regularMaterial)
            .cornerRadius(12)
            .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            .opacity(isFlipped ? 0 : 1)
            
            // BACK
            VStack(alignment: .leading, spacing: 6) {
                Text(flashcard.answer)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                Text("Answer")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: 250)
            .background(.regularMaterial)
            .cornerRadius(12)
            .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
            .opacity(isFlipped ? 1 : 0)
        }
        .onTapGesture{
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                isFlipped.toggle()
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel (isFlipped ? "Answer: \(flashcard.answer)" : "Question: \(flashcard.question)")
    }
}

