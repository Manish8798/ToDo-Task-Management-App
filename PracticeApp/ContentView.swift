//
//  ContentView.swift
//  PracticeApp
//
//  Created by Manish Kumar on 24/01/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var text: String = ""
    @State private var editingTask: TaskModel? = nil
    @State private var addTaskSheet: Bool = false
    @State private var showingDeleteConfirmation: Bool = false
    @State private var taskToDelete: TaskModel? = nil
    @Query private var todos: [TaskModel] = []
    
    var body: some View {
        NavigationStack { // Wrap in NavigationStack to use toolbar
            VStack {
                if todos.isEmpty {
                    Button(action: {
                        editingTask = nil
                        text = ""
                        addTaskSheet = true
                    }, label: {
                        VStack{
                            Image(systemName: "plus.app")
                                .resizable()
                                .frame(width: 50, height: 50)
                            Text("Add Task")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.vertical, 5)
                        }
                    })
                    
                } else {
                    ScrollView {
                        ForEach(Array(todos.enumerated()), id: \.offset) { index, task in
                            HStack {
                                Text("\(index + 1). ")
                                // Checkbox Toggle
                                Toggle("", isOn: Binding(
                                    get: { task.isCompleted },
                                    set: { newValue in
                                        // Update the task's completion status
                                        task.isCompleted = newValue
                                    }
                                ))
                                .labelsHidden()
                                .toggleStyle(CheckboxStyle())
                                
                                // Task title with strikethrough when completed
                                Text("\(task.title)")
                                    .lineLimit(2)  // Limits the text to 2 lines
                                    .truncationMode(.tail)
                                    .strikethrough(task.isCompleted, color: .gray)
                                    .foregroundColor(task.isCompleted ? .gray : .primary)
                                    .onTapGesture{
                                        editingTask = task
                                        text = task.title
                                        addTaskSheet = true
                                    }
                                
                                Spacer()
                                
                                Button(action: {
                                    taskToDelete = task
                                    showingDeleteConfirmation = true
                                }, label: {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(Color.red)
                                })
                            }.padding()
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Tasks") // Add a navigation title
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        editingTask = nil
                        text = ""
                        addTaskSheet = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
            }
            .sheet(isPresented: $addTaskSheet) {
                // You can create a separate view for adding tasks
                AddTask(addTaskSheet: $addTaskSheet, text: $text, editingTask: $editingTask)
                .presentationDetents([.medium]) // Makes the sheet not full screen
            }
            .alert("Delete Task", isPresented: $showingDeleteConfirmation, presenting: taskToDelete) { task in
                Button("Delete", role: .destructive) {
                    modelContext.delete(task)
                }
                Button("Cancel", role: .cancel) {}
            } message: { task in
                Text("Are you sure you want to delete this task?")
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TaskModel.self, inMemory: true)
}
