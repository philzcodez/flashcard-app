//
//  FlashcardsView.swift
//  GoStudy
//
//  Created by Phillip Bilenko on 2/9/26.
//

import SwiftUI


struct FlashcardsView: View {
    @Binding private var flashcards: [Flashcard]
    @State private var showAddCard = false
    @State private var currentIndex = 0
    @State private var isFlipped = false
    
    //Explicit initializer
    init(flashcards: Binding <[Flashcard]>) {
        self._flashcards = flashcards
    }
    private var totalCards: Int {
        flashcards.count
    }
    
    private var progress: Double {
        guard totalCards > 0 else { return 0 }
        return Double(currentIndex + 1) / Double(totalCards)
    }
    var body: some View {
        VStack(spacing: 16) {
            //Progress text
            Text("Card \(currentIndex + 1) of \(totalCards)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            //Progress bar
            ProgressView(value: progress)
                .padding(.horizontal)
            
            if !flashcards.isEmpty {
                FlashcardRow(flashcard: flashcards[currentIndex], isFlipped: $isFlipped)
                    .id(currentIndex)
            } else {
                Text("No flashcards yet")
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Button("Previous") {
                    if currentIndex > 0 {
                        currentIndex -= 1
                    }
                }
                .disabled(currentIndex == 0)
                
                Spacer()
                
                Button("Next") {
                    if currentIndex < totalCards - 1 {
                        currentIndex += 1
                    }
                }
                .disabled(currentIndex >= totalCards - 1)
            }
            .padding(.horizontal)
        }
        .onChange(of: currentIndex) {_, _ in
            isFlipped = false
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Flashcards")
        .toolbar {
            Button {
                showAddCard = true
            } label: {
                Image(systemName: "plus")
            }
            
            Button {
                resetAndShuffle()
            } label: {
                Image(systemName: "shuffle")
            }
            
            EditButton()
        }
        .sheet(isPresented: $showAddCard) {
            AddFlashcardView(flashcards: $flashcards)
        }
    }
    private func deleteFlashcards(at offsets: IndexSet) {
        flashcards.remove(atOffsets: offsets)
    }
    private func resetAndShuffle() {
        flashcards.shuffle()
        currentIndex = 0
    }
}

#Preview {
    FlashcardsView(flashcards: .constant(sampleFlashcards))
}
