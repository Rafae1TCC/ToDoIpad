//
//  TaskGroupDetailView.swift
//  ToDo Task
//
//  Created by Gabriela Sanchez on 09/12/25.
//

import SwiftUI

struct TaskGroupDetailView: View {
    @Binding var groups: TaskGroup
    @Environment(\.horizontalSizeClass) var sizeClass
    @State private var isShowingNewTask = false
    
    var body: some View {
        List {
            Section {
                if sizeClass == .regular {
                    GroupStatsView(tasks: groups.tasks)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color(.secondarySystemBackground))
                        .accessibilityIdentifier("groupStatsView")
                }
                
                ForEach($groups.tasks) { $task in
                    HStack {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(task.isCompleted ? .cyan : .gray)
                            .onTapGesture {
                                withAnimation {
                                    task.isCompleted.toggle()
                                }
                            }
                            .accessibilityIdentifier("completeTaskBtn")
                        if let fileName = task.drawingFileName, let image = DrawingStorage.load(fileName) {
                            DrawingTaskImage(image: image)
                                .opacity(task.isCompleted ? 0.4 : 1)
                                .accessibilityIdentifier("taskDrawingImage")
                            Spacer()
                        } else {
                            TextField("Task Title", text: $task.title)
                                .strikethrough(task.isCompleted)
                                .accessibilityIdentifier("taskTitleTextField")
                        }
                    }
                }
                .onDelete { index in
                    for i in index {
                        if let fileName = groups.tasks[i].drawingFileName {
                            DrawingStorage.delete(fileName)
                        }
                    }
                    groups.tasks.remove(atOffsets: index)
                }
            }
        }
        .accessibilityIdentifier("tasksList")
        .navigationTitle(groups.title)
        .toolbar {
            Button("Add Task") {
                isShowingNewTask = true
            }
            .accessibilityIdentifier("addTaskBtn")
        }
        .sheet(isPresented: $isShowingNewTask) {
            NewTaskView { task in
                withAnimation {
                    groups.tasks.append(task)
                }
                isShowingNewTask = false
            }
        }
    }
}

struct DrawingTaskImage: View {
    let image: UIImage

    var body: some View {
        let scale = min(300 / image.size.width, 120 / image.size.height, 1)
        Image(uiImage: image)
            .resizable()
            .frame(width: image.size.width * scale, height: image.size.height * scale)
            .padding(.vertical, 4)
    }
}
