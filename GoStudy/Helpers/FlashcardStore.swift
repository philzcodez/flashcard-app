//
//  FlashcardStore.swift
//  GoStudy
//
//  Created by Phillip Bilenko on 2/13/26.
//

import Foundation

class FlashcardStore {
    private let key = "saved_flashcards"

    func save(_ flashcards: [Flashcard]) {
        if let data = try? JSONEncoder().encode(flashcards) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func load() -> [Flashcard] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let flashcards = try? JSONDecoder().decode([Flashcard].self, from: data) else {
            return []
        }
        return flashcards
    }
}
