import SwiftUI

struct HomeView: View {
    @State private var flashcards: [Flashcard] = []
    @State private var sessions: [StudySession] = []
    private let store = FlashcardStore()
    
    var body: some View {
        NavigationStack {
            // Pre-define the destination views for smoother type checking
            let flashcardsView = FlashcardsView(flashcards: $flashcards, sessions: $sessions)
            let sessionHistoryView = SessionHistoryView(sessions: $sessions)
            
            VStack(spacing: 16) {
                Image(systemName: "book.fill")
                    .font(.system(size: 48))

                Text("Welcome to GoStudy")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("Your study starts here.")
                    .foregroundStyle(.secondary)
                
                NavigationLink("Study Flashcards") {
                    flashcardsView
                }
                .buttonStyle(.borderedProminent)
                
                NavigationLink("Session History") {
                    sessionHistoryView
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Home")
            .onAppear {
                flashcards = store.load()
                sessions = store.loadSessions()
            }
            .onChange(of: flashcards) { _, newValue in
                store.save(newValue)
            }
            .onChange(of: sessions) { _, newValue in
                store.saveSessions(newValue)
            }
        }
    }
}

#Preview {
    HomeView()
}
