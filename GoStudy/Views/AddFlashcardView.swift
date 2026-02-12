//
//  AddFlashcardView.swift
//  GoStudy
//
//  Created by Phillip Bilenko on 2/12/26.
//

import SwiftUI

struct AddFlashcardView: View {
    @Binding var flashcards: [Flashcard]
    @Environment(\.dismiss) private var dismiss
    
    @State private var question = ""
    @State private var answer = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Question")) {
                    TextField("Enter question", text: $question)
                }
                
                Section(header: Text("Answer")) {
                    TextField("Enter answer", text: $answer)
                }
            }
            .navigationTitle("New Flashcard")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveFlashcard()
                    }
                    .disabled(question.isEmpty || answer.isEmpty)
                }
            }
        }
    }
    
    private func saveFlashcard() {
        let newCard = Flashcard(question: question, answer: answer)
        flashcards.append(newCard)
        dismiss()
    }
}
