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
            Group{
                if sessions.isEmpty {
                    Text("No study sessions yet")
                        .foregroundStyle(.secondary)
                        .padding()
                } else {
                    List {
                        ForEach(sessions) { session in
                            SessionRow(session: session)
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
                }
            }
            .alert("Clear all sessions?", isPresented: $showClearAllAlert) {
                Button("Clear", role: .destructive) {
                    sessions.removeAll()
                }
                Button("Cancel", role: .cancel){}
            } message: {
                Text("This cannot be undone.")
            }
        }
    }

    private func deleteSession(at offsets: IndexSet) {
        sessions.remove(atOffsets: offsets)
    }
}

private struct SessionRow: View {
    let session: StudySession

    private var studiedText: String { "Studied \(session.cardsStudied) cards" }
    private var durationText: String { "Duration \(session.durationString)" }
    private var timeRangeText: String {
        let start = session.startTime.formatted(date: .abbreviated, time: .shortened)
        let end = session.endTime.formatted(date: .omitted, time: .shortened)
        return "\(start) → \(end)"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(studiedText)
                .font(.headline)

            Text(durationText)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(timeRangeText)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    SessionHistoryView(sessions: .constant([
        StudySession(
            startTime: Date().addingTimeInterval(-1800),
            endTime: Date(),
            cardsStudied: 6
        ),
        StudySession(
            startTime: Date().addingTimeInterval(-3600),
            endTime: Date().addingTimeInterval(-1800),
            cardsStudied: 4
        )
    ]))
}

