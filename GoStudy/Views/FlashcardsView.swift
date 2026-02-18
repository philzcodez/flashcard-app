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
    @State private var isFocusMode = true
    @State private var sessionStartTime = Date()
    @State private var sessionCardsStudied = 0
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    let haptic = UIImpactFeedbackGenerator(style: .light)
    
    //Explicit initializer
    init(flashcards: Binding <[Flashcard]>) {
        self._flashcards = flashcards
    }
    
    private var cardsRemaining: Int {
        max(totalCards - currentIndex - 1, 0)
    }
    
    private var cardsStudied: Int {
        currentIndex
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
            
            HStack {
                Text("Studied: \(cardsStudied)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("Remaing: \(cardsRemaining)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            
            //Progress bar
            ProgressView(value: progress)
                .padding(.horizontal)
            
            if !flashcards.isEmpty {
                FlashcardRow(flashcard: flashcards[currentIndex], isFlipped: $isFlipped)
                    .id(currentIndex)
                    .padding(.vertical, 24)
                    .scaleEffect(isFocusMode ? 1.05 : 1.0)
                    .animation(reduceMotion ? nil : .easeInOut(duration: 0.25), value: isFocusMode)
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
                        sessionCardsStudied = 0
                        sessionStartTime = Date()
                    } else {
                        currentIndex += 1
                        haptic.impactOccurred()
                        sessionCardsStudied += 1
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
        .navigationTitle(isFocusMode ? "" : "Flashcards")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !isFocusMode {
                Button {
                    showAddCard = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Add flashcard")
                
                Button {
                    resetAndShuffle()
                } label: {
                    Image(systemName: "shuffle")
                }
                .accessibilityLabel("Shuffle flashcards")
                
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label : {
                    Image(systemName: "trash")
                }
                .disabled(flashcards.isEmpty)
                .accessibilityLabel("Delete current flashcard")
                
                Button {
                    withAnimation {
                        currentIndex = 0
                        isFlipped = false
                        sessionCardsStudied = 0
                        sessionStartTime = Date()
                    }
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                }
                .accessibilityLabel("Restart session")
                .disabled(flashcards.isEmpty)
            }
            
            Button {
                withAnimation {
                    isFocusMode.toggle()
                }
            } label: {
                Image(systemName: isFocusMode ? "eye.slash" : "eye")
            }
            .accessibilityLabel(isFocusMode ? "Exit focus mode" : "Enter focus mode")
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
