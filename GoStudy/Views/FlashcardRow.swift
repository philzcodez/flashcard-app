//
//  FlashcardRow.swift
//  GoStudy
//
//  Created by Phillip Bilenko on 2/12/26.
//

import SwiftUI

struct FlashcardRow: View {
    let flashcard: Flashcard
    @State private var isFlipped = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(isFlipped ? flashcard.answer: flashcard.question)
                .font(.headline)
                .foregroundStyle(.primary)
            
            Text(isFlipped ? "Answer" : "Question")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial)
        .cornerRadius(12)
        .onTapGesture {
            isFlipped.toggle()
        }
    }
}

