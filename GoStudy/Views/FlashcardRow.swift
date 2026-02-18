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
    let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    private var rotation: Double {
        isFlipped ? 180 : 0
    }
    
    var body: some View {
        ZStack{
            if isFlipped {
                backView
            } else {
                frontView
            }
        }
        .accessibilityLabel(
            isFlipped
            ? "Answer: \(flashcard.answer)"
            : "Question: \(flashcard.question)"
        )
        .rotation3DEffect(
            .degrees(rotation),
            axis: (x: 0, y: 1, z:0)
        )
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.5), value: isFlipped)
        .onTapGesture{
            isFlipped.toggle()
            haptic.impactOccurred()
        }
    }
    
    
    private var frontView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(flashcard.question)
                .font(.headline)
            Text("Tap to reveal")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: 500, minHeight: 250)
        .background(.regularMaterial)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.15), radius: 12, y: 6)
    }
    
    private var backView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(flashcard.answer)
                .font(.headline)
            Text("Answer")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: 500, minHeight: 250)
        .background(.regularMaterial)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.15), radius: 12, y: 6)
        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
    }
    
    
    private func cardFace(text: String, subtitle: String) -> some View {
        VStack(spacing: 12) {
            Spacer()
            
            Text(text)
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .padding(24)
        .frame(maxWidth: 500)
        .frame(height: 260)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.15), radius: 12, y: 6)
    }
    
}

