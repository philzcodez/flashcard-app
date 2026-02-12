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
    
    //Explicit initializer
    init(flashcards: Binding <[Flashcard]>) {
        self._flashcards = flashcards
    }
    
    var body: some View {
        List {
            ForEach(flashcards) { card in
                FlashcardRow(flashcard: card)
            }
            .onDelete(perform: deleteFlashcards)
        }
        .navigationTitle("Flashcards")
        .toolbar {
            Button {
                showAddCard = true
            } label: {
                Image(systemName: "plus")
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
}

#Preview {
    FlashcardsView(flashcards: .constant(sampleFlashcards))
}
