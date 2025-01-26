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
    @State private var description: String = ""
    @State private var taskPriority: Int = 0
    @State private var editingTask: TaskModel? = nil
    @State private var addTaskSheet: Bool = false
    @State private var showingDeleteConfirmation: Bool = false
    @State private var taskToDelete: TaskModel? = nil
    @Query(sort: \TaskModel.priority, order: .reverse) private var todos: [TaskModel]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                // Existing content with conditional rendering
                VStack {
                    if todos.isEmpty {
                        // Empty state view
                        
                        VStack(spacing: 10) {
                            Spacer()
                            
                            Image(systemName: "list.bullet")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray.opacity(0.5))
                            
                            Text("No tasks yet")
                                .font(.title2)
                                .foregroundColor(.gray)
                            
                            Text("Tap the + button to add your first task")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Spacer()
                        }.frame(maxWidth: .infinity, maxHeight: .infinity) // Ensures full-screen centering
                        
                    } else {
                        ScrollView {
                            ForEach(Array(todos.enumerated()), id: \.offset) { index, task in
                                HStack {
                                    Text("\(index + 1). ")
                                    
                                    Toggle("", isOn: Binding(
                                        get: { task.isCompleted },
                                        set: { newValue in
                                            task.isCompleted = newValue
                                        }
                                    ))
                                    .labelsHidden()
                                    .toggleStyle(CheckboxStyle())
                                    
                                    Text("\(task.title)")
                                        .lineLimit(2)
                                        .truncationMode(.tail)
                                        .strikethrough(task.isCompleted, color: .gray)
                                        .foregroundColor(task.isCompleted ? .gray : .primary)
                                        .onTapGesture {
                                            editingTask = task
                                            text = task.title
                                            description = task.desc ?? ""
                                            taskPriority = task.priority
                                            addTaskSheet = true
                                        }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        taskToDelete = task
                                        showingDeleteConfirmation = true
                                    }) {
                                        Image(systemName: "trash.fill")
                                            .foregroundColor(Color.red)
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
                .padding()
                .navigationTitle("Tasks (\(todos.count))")
                
                // Floating Action Button
                FloatingActionButton(action: {
                    editingTask = nil
                    text = ""
                    description = ""
                    addTaskSheet = true
                }).padding()
                  .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
            .sheet(isPresented: $addTaskSheet) {
                AddTask(addTaskSheet: $addTaskSheet, text: $text, description: $description, taskPriority: $taskPriority, editingTask: $editingTask)
                    .presentationDetents([.large])
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

// Reusable Floating Action Button
struct FloatingActionButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3)
        }
        .padding(16)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TaskModel.self, inMemory: true)
}
