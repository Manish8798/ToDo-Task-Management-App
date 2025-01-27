//
//  AddTask.swift
//  PracticeApp
//
//  Created by Manish Kumar on 25/01/25.
//
import SwiftUI
import SwiftData

struct AddTask: View {
    private let textLimit = 50 // Set your desired character limit here
    @Binding var addTaskSheet: Bool
    @Binding var text: String
    @Binding var description: String
    @Binding var taskPriority: Int
    @Binding var editingTask: TaskModel? // New binding to handle editing
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $text)
                        .frame(height: 40)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding()
                        .onChange(of: text) { oldValue, newValue in
                            if newValue.count > textLimit {
                                text = String(newValue.prefix(textLimit))
                            }
                        }
                    
                    if text.isEmpty {
                        Text("Enter task title...")
                            .foregroundColor(.gray)
                            .padding(.leading, 20)
                            .padding(.top, 25)
                    }
                    
                }
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $description)
                        .frame(height: 150)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding()
                    
                    // Optional: Add placeholder text
                    if description.isEmpty {
                        Text("Enter task description...")
                            .foregroundColor(.gray)
                            .padding(.leading, 20)
                            .padding(.top, 25)
                    }
                }
                
                HStack {
                    Text("Priority: ")
                        .font(.headline)
                    
                    ForEach([(0, "Low"), (5, "Medium"), (10, "High")], id: \.0) { priorityValue, title in
                        Button(action: {
                            taskPriority = priorityValue
                        }) {
                            Text(title)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(taskPriority == priorityValue ? Color.blue : Color.gray.opacity(0.2))
                                .foregroundColor(taskPriority == priorityValue ? .white : .black)
                                .cornerRadius(8)
                        }
                    }
                }.padding()
                
//                Button(editingTask == nil ? "Add Task" : "Update Task") {
//                    if !text.isEmpty {
//                        if let taskToEdit = editingTask {
//                            // Update existing task
//                            taskToEdit.title = text
//                            taskToEdit.desc = description
//                            taskToEdit.priority = taskPriority
//                        } else {
//                            // Create new task
//                            let task = TaskModel(title: text, isCompleted: false, priority: taskPriority, desc: description)
//                            modelContext.insert(task)
//                        }
//                        
//                        text = ""
//                        description = ""
//                        addTaskSheet = false
//                        editingTask = nil
//                    }
//                }
                
                Button(action: {
                    if !text.isEmpty {
                        if let taskToEdit = editingTask {
                            // Update existing task
                            taskToEdit.title = text
                            taskToEdit.desc = description
                            taskToEdit.priority = taskPriority
                        } else {
                            // Create new task
                            let task = TaskModel(title: text, isCompleted: false, priority: taskPriority, desc: description)
                            modelContext.insert(task)
                        }
                        
                        text = ""
                        description = ""
                        addTaskSheet = false
                        editingTask = nil
                    }
                }) {
                    Text(editingTask == nil ? "Add Task" : "Update Task")
                        .font(.headline)
                        .frame(maxWidth: .infinity) // Makes it stretch to full width
                        .padding()
                        .background(editingTask == nil ? Color.blue : Color.green) // Blue for add, Green for update
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)// Adds padding on the sides

                
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(editingTask == nil ? "Add New Task" : "Edit Task")
                        .font(.title) // Adjust font size as needed
                        .fontWeight(.bold) // Optional: Make it bold
                }
            }
            .navigationBarItems(trailing: Button(action: {
                addTaskSheet = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    editingTask = nil
                }
            }) {
                Image(systemName: "xmark.circle.fill") // Example icon
                    .foregroundColor(.gray)
            })
        }
        
    }
}
