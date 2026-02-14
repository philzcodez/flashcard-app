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
                Text("Your study starts here.")
                    .foregroundStyle(.secondary)
                NavigationLink("Go to Flashcards") {
                    FlashcardsView(flashcards: $flashcards)
                }
                    .buttonStyle(.borderedProminent)
                NavigationLink("Create a New Card") {
                    CreateCardView()
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
