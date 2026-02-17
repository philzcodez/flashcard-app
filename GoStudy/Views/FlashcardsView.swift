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
    @State private var showDeleteAlert = false
    
    let haptic = UIImpactFeedbackGenerator(style: .light)
    
    //Explicit initializer
    init(flashcards: Binding <[Flashcard]>) {
        self._flashcards = flashcards
    }
    
    private var isLastCard: Bool {
        currentIndex == totalCards - 1
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
                    .padding(.vertical, 24)
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
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .buttonStyle(.bordered)
                .controlSize(.small)
                .disabled(currentIndex == 0)
                
                Spacer()
                
                Button(isLastCard ? "Done" : "Next") {
                    if isLastCard {
                        resetAndShuffle()
                        haptic.impactOccurred()
                    } else {
                        currentIndex += 1
                        haptic.impactOccurred()
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .buttonStyle(.bordered)
                .controlSize(.small)
                .disabled(flashcards.isEmpty)
            }
            .padding(.horizontal)
        }
        .alert("Delete this card?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                deleteCurrentCard()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone.")
        }
        .animation(.easeInOut, value: currentIndex)
        .onChange(of: currentIndex) {_, _ in
            isFlipped = false
        }
        .onChange(of: flashcards){ _, _ in
            clampIndex()
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
            
            Button(role: .destructive) {
                showDeleteAlert = true
            } label : {
                Image(systemName: "trash")
            }
            .disabled(flashcards.isEmpty)
            
            EditButton()
        }
        .sheet(isPresented: $showAddCard) {
            AddFlashcardView(flashcards: $flashcards)
        }
    }
    private func deleteCurrentCard() {
        guard !flashcards.isEmpty else {return}
        
        flashcards.remove(at: currentIndex)
        clampIndex()
        isFlipped = false
        haptic.impactOccurred()
    }
    
    private func clampIndex() {
        if flashcards.isEmpty {
            currentIndex = 0
        } else if currentIndex < 0 {
            currentIndex = 0
        } else if currentIndex >= flashcards.count {
            currentIndex = flashcards.count - 1
        }
    }
    
    private func resetAndShuffle() {
        flashcards.shuffle()
        currentIndex = 0
        isFlipped = false
        haptic.impactOccurred()
    }
}

#Preview {
    FlashcardsView(flashcards: .constant(sampleFlashcards))
}
