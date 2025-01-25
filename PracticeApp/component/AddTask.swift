//
//  AddTask.swift
//  PracticeApp
//
//  Created by Manish Kumar on 25/01/25.
//
import SwiftUI
import SwiftData

struct AddTask: View {
    
    @Binding var addTaskSheet: Bool
    @Binding var text: String
    @Binding var editingTask: TaskModel? // New binding to handle editing
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        
        NavigationView {
            VStack {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $text)
                        .frame(height: 150)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding()
                    
                    // Optional: Add placeholder text
                    if text.isEmpty {
                        Text("Enter task title...")
                            .foregroundColor(.gray)
                            .padding(.leading, 20)
                            .padding(.top, 25)
                    }
                }
                
                Button(editingTask == nil ? "Add Task" : "Update Task") {
                    if !text.isEmpty {
                        if let taskToEdit = editingTask {
                            // Update existing task
                            taskToEdit.title = text
                        } else {
                            // Create new task
                            let task = TaskModel(title: text, isCompleted: false, priority: 0)
                            modelContext.insert(task)
                        }
                        
                        text = ""
                        addTaskSheet = false
                        editingTask = nil
                    }
                }
            }
            .navigationTitle(editingTask == nil ? "Add New Task" : "Edit Task")
            .navigationBarItems(trailing: Button("Cancel") {
                addTaskSheet = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    editingTask = nil
                }
            })
        }
        
    }
}
