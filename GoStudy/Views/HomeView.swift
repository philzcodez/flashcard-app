import SwiftUI

struct HomeView: View {
    @State private var  flashcards: [Flashcard] = sampleFlashcards
    private let store = FlashcardStore()
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "book.fill")
                    .font(.system(size: 48))

                Text("Welcome to GoStudy")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("Your study starts here.")
                    .foregroundStyle(.secondary)
                
                NavigationLink("Study Flashcards") {
                    FlashcardsView(flashcards: $flashcards)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Home")
            .onAppear {
                flashcards = store.load()
            }
            .onChange(of: flashcards) {_, newValue in
                store.save(newValue)
            }
        }
    }
}

#Preview {
    HomeView()
}
