//
//  NewTaskView.swift
//  ToDoIpad
//
//  Created by Rafael Cabrera on 10/20/26.
//


import SwiftUI

struct NewTaskView: View {
    @Environment(\.dismiss) var dismiss
    var onSave: (TaskItem) -> Void

    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    TextTaskView(onSave: onSave)
                } label: {
                    Label("Text Task", systemImage: "text.justify.leading")
                }
                .accessibilityIdentifier("textTaskBtn")

                NavigationLink {
                    DrawingTaskView(onSave: onSave)
                } label: {
                    Label("Drawing Task", systemImage: "pencil.tip")
                }
                .accessibilityIdentifier("drawingTaskBtn")
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("cancelNewTaskBtn")
                }
            }
        }
    }
}

struct TextTaskView: View {
    @State private var text = ""
    var onSave: (TaskItem) -> Void

    var body: some View {
        Form {
            TextField("Task Title", text: $text)
                .accessibilityIdentifier("newTaskTitleTextField")
        }
        .navigationTitle("Text Task")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    onSave(TaskItem(title: text))
                }
                .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
                .accessibilityIdentifier("saveTextTaskBtn")
            }
        }
    }
}
