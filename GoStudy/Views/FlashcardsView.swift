//
//  FlashcardsView.swift
//  GoStudy
//
//  Created by Phillip Bilenko on 2/9/26.
//

import SwiftUI
import Combine


struct FlashcardsView: View {
    @Binding private var flashcards: [Flashcard]
    @State private var showAddCard = false
    @State private var currentIndex = 0
    @State private var isFlipped = false
    @State private var showDeleteAlert = false
    @State private var isFocusMode = true
    @State private var sessionStartTime = Date()
    @State private var sessionCardsStudied = 0
    @State private var sessions: [StudySession] = []
    @State private var elapsedSeconds = 0
    @State private var timerRunning = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
    

    private var addButton: some View {
        Button {
            showAddCard = true
        } label: {
            Image(systemName: "plus")
        }
        .accessibilityLabel("Add flashcard")
    }

    private var shuffleButton: some View {
        Button {
            resetAndShuffle()
        } label: {
            Image(systemName: "shuffle")
        }
        .accessibilityLabel("Shuffle flashcards")
    }

    private var deleteButton: some View {
        Button(role: .destructive) {
            showDeleteAlert = true
        } label: {
            Image(systemName: "trash")
        }
        .disabled(flashcards.isEmpty)
        .accessibilityLabel("Delete current flashcard")
    }

    private var restartButton: some View {
        Button {
            withAnimation {
                currentIndex = 0
                isFlipped = false
                sessionCardsStudied = 0
                sessionStartTime = Date()
                elapsedSeconds = 0
                timerRunning = true
            }
        } label: {
            Image(systemName: "arrow.counterclockwise")
        }
        .disabled(flashcards.isEmpty)
        .accessibilityLabel("Restart session")
    }

    private var repeatButton: some View {
        Button {
            withAnimation {
                currentIndex = 0
                isFlipped = false
                sessionCardsStudied = 0
                sessionStartTime = Date()
            }
        } label: {
            Image(systemName: "repeat")
        }
        .disabled(flashcards.isEmpty)
        .accessibilityLabel("Repeat current session")
    }

    private func advanceCard() {
        if isLastCard {
            //Log session
            let completedSession = StudySession(
                startTime: sessionStartTime,
                endTime: Date(),
                cardsStudied: sessionCardsStudied + 1
            )
            sessions.append(completedSession)
            
            resetAndShuffle()
            sessionCardsStudied = 0
            sessionStartTime = Date()
            haptic.impactOccurred()
        } else {
            currentIndex += 1
            haptic.impactOccurred()
            sessionCardsStudied += 1
        }
    }
    
    private var currentFlashcardView: some View {
        FlashcardRow(flashcard: flashcards[currentIndex], isFlipped: $isFlipped)
            .padding(.vertical, 24)
            .scaleEffect(isFocusMode ? 1.05 : 1.0)
            .animation(reduceMotion ? nil : .easeInOut(duration: 0.25), value: isFocusMode)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            //Progress text
            Text("Card \(currentIndex + 1) of \(totalCards)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text("Time: \(elapsedSeconds) sec")
                .font(.caption)
                .foregroundStyle(.secondary)
                .onReceive(timer) { _ in
                    if timerRunning { elapsedSeconds += 1}
                }
            
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
                currentFlashcardView
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
                
                Button(isLastCard ? "Done" : "Next"){
                    advanceCard()
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .buttonStyle(.bordered)
                .controlSize(.small)
                .disabled(flashcards.isEmpty)
                .onAppear{
                    timerRunning = true
                    sessionStartTime = Date()
                }
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
                addButton
                shuffleButton
                deleteButton
                restartButton
                repeatButton
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
        elapsedSeconds = 0
        timerRunning = true
        haptic.impactOccurred()
    }
}

#Preview {
    FlashcardsView(flashcards: .constant(sampleFlashcards))
}
