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
    @Query private var todos: [TaskModel] = []
    
    var body: some View {
        NavigationStack { // Wrap in NavigationStack to use toolbar
            VStack {
                
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
                                modelContext.delete(task)
                            }, label: {
                                Image(systemName: "trash.fill")
                                    .foregroundColor(Color.red)
                            })
                        }.padding()
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
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TaskModel.self, inMemory: true)
}
