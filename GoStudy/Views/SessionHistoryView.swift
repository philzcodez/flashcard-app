//
//  SessionHistoryView.swift
//  GoStudy
//
//  Created by Phillip Bilenko on 2/18/26.
//

import SwiftUI

struct SessionHistoryView: View {
    @Binding var sessions: [StudySession]
    @State private var showClearAllAlert = false

    var body: some View {
        NavigationStack {
            VStack {
                if sessions.isEmpty {
                    Text("No study sessions yet")
                        .foregroundStyle(.secondary)
                        .padding()
                } else {
                    List {
                        ForEach(sessions) { session in
                            VStack(alignment: .leading) {
                                Text("Studied \(session.cardsStudied) cards")
                                    .font(.headline)
                                Text("Time: \(session.startTime.formatted(date: .abbreviated, time: .shortened)) - \(session.endTime.formatted(date: .abbreviated, time: .shortened))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: deleteSession)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Session History")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear All") {
                        showClearAllAlert = true
                    }
                    .disabled(sessions.isEmpty)
                    .alert("Clear all sessions?", isPresented: $showClearAllAlert) {
                        Button("Clear", role: .destructive) {
                            sessions.removeAll()
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("This cannot be undone.")
                    }
                }
            }
        }
    }

    private func deleteSession(at offsets: IndexSet) {
        sessions.remove(atOffsets: offsets)
    }
}

#Preview {
    SessionHistoryView(sessions: .constant([
        StudySession(startTime: Date().addingTimeInterval(-3600), endTime: Date(), cardsStudied: 5),
        StudySession(startTime: Date().addingTimeInterval(-7200), endTime: Date().addingTimeInterval(-3600), cardsStudied: 3)
    ]))
}
