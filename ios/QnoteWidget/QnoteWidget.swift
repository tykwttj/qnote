//
//  QnoteWidget.swift
//  QnoteWidget
//
//  Created by 豊川哲次 on 2026/03/15.
//

import WidgetKit
import SwiftUI

// MARK: - Timeline Entry

struct MemoEntry: TimelineEntry {
    let date: Date
    let memos: [(title: String, body: String, pinned: Bool)]
}

// MARK: - Timeline Provider

struct QnoteProvider: TimelineProvider {
    private let appGroupId = "group.com.qnote.widget"

    func placeholder(in context: Context) -> MemoEntry {
        MemoEntry(
            date: Date(),
            memos: [
                (title: "Shopping List", body: "Milk, eggs, bread", pinned: true),
                (title: "Meeting Notes", body: "Review Q1 goals", pinned: false),
                (title: "Ideas", body: "App feature brainstorm", pinned: false)
            ]
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (MemoEntry) -> Void) {
        completion(loadEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MemoEntry>) -> Void) {
        let entry = loadEntry()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }

    private func loadEntry() -> MemoEntry {
        let defaults = UserDefaults(suiteName: appGroupId)
        var memos: [(title: String, body: String, pinned: Bool)] = []

        for i in 0..<5 {
            if let title = defaults?.string(forKey: "memo_\(i)_title"), !title.isEmpty {
                let body = defaults?.string(forKey: "memo_\(i)_body") ?? ""
                let pinned = defaults?.bool(forKey: "memo_\(i)_pinned") ?? false
                memos.append((title: title, body: body, pinned: pinned))
            }
        }

        if memos.isEmpty {
            memos.append((title: "No memos yet", body: "Tap to create one", pinned: false))
        }

        return MemoEntry(date: Date(), memos: memos)
    }
}

// MARK: - Small Widget View

struct QnoteSmallView: View {
    var entry: MemoEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Qnote")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.357, green: 0.416, blue: 0.749))
                Spacer()
            }

            if let first = entry.memos.first {
                HStack(spacing: 2) {
                    if first.pinned {
                        Image(systemName: "pin.fill")
                            .font(.system(size: 8))
                            .foregroundColor(Color(red: 0.357, green: 0.416, blue: 0.749))
                    }
                    Text(first.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                }
                Text(first.body)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }

            Spacer()
        }
        .padding(12)
    }
}

// MARK: - Medium Widget View

struct QnoteMediumView: View {
    var entry: MemoEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Qnote")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.357, green: 0.416, blue: 0.749))
                Spacer()
                Text("\(entry.memos.count) notes")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Divider()

            ForEach(Array(entry.memos.prefix(3).enumerated()), id: \.offset) { _, memo in
                HStack(spacing: 4) {
                    if memo.pinned {
                        Image(systemName: "pin.fill")
                            .font(.system(size: 8))
                            .foregroundColor(Color(red: 0.357, green: 0.416, blue: 0.749))
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        Text(memo.title)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                        Text(memo.body)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    Spacer()
                }
            }

            Spacer()
        }
        .padding(12)
    }
}

// MARK: - Large Widget View

struct QnoteLargeView: View {
    var entry: MemoEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Qnote")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.357, green: 0.416, blue: 0.749))
                Spacer()
                Text("\(entry.memos.count) notes")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Divider()

            ForEach(Array(entry.memos.prefix(5).enumerated()), id: \.offset) { index, memo in
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        if memo.pinned {
                            Image(systemName: "pin.fill")
                                .font(.system(size: 9))
                                .foregroundColor(Color(red: 0.357, green: 0.416, blue: 0.749))
                        }
                        Text(memo.title)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                    }
                    Text(memo.body)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                if index < min(entry.memos.count, 5) - 1 {
                    Divider().opacity(0.5)
                }
            }

            Spacer()
        }
        .padding(12)
    }
}

// MARK: - Widget Definitions

struct QnoteWidgetSmall: Widget {
    let kind: String = "QnoteWidgetSmall"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QnoteProvider()) { entry in
            QnoteSmallView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Qnote Quick")
        .description("View your latest memo")
        .supportedFamilies([.systemSmall])
    }
}

struct QnoteWidgetMedium: Widget {
    let kind: String = "QnoteWidgetMedium"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QnoteProvider()) { entry in
            QnoteMediumView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Qnote List")
        .description("View your recent memos")
        .supportedFamilies([.systemMedium])
    }
}

struct QnoteWidgetLarge: Widget {
    let kind: String = "QnoteWidgetLarge"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QnoteProvider()) { entry in
            QnoteLargeView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Qnote Board")
        .description("View all your important memos")
        .supportedFamilies([.systemLarge])
    }
}
