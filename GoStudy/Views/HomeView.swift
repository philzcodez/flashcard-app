import SwiftUI

struct HomeView: View {
    @State private var  flashcards: [Flashcard] = sampleFlashcards
    private let store = FlashcardStore()
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "book.fill")
                    .imageScale(.large)
                    .font(.system(size: 48))
                    .foregroundStyle(.tint)
                Text("Welcome to GoStudy")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("Your studying starts here.")
                    .foregroundStyle(.secondary)
                NavigationLink("Enter") {
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
