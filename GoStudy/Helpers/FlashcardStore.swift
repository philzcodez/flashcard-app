//
//  FlashcardStore.swift
//  GoStudy
//
//  Created by Phillip Bilenko on 2/13/26.
//

import Foundation

class FlashcardStore {
    private let flashcardsKey = "saved_flashcards"
    private let sessionsKey = "saved_sessions"

    // Flashcards
    func save(_ flashcards: [Flashcard]) {
        if let data = try? JSONEncoder().encode(flashcards) {
            UserDefaults.standard.set(data, forKey: flashcardsKey)
        }
    }

    func load() -> [Flashcard] {
        guard let data = UserDefaults.standard.data(forKey: flashcardsKey),
              let flashcards = try? JSONDecoder().decode([Flashcard].self, from: data) else {
            return []
        }
        return flashcards
    }

    // Sessions
    func saveSessions(_ sessions: [StudySession]) {
        if let data = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(data, forKey: sessionsKey)
        }
    }

    func loadSessions() -> [StudySession] {
        guard let data = UserDefaults.standard.data(forKey: sessionsKey),
              let sessions = try? JSONDecoder().decode([StudySession].self, from: data) else {
            return []
        }
        return sessions
    }
}

