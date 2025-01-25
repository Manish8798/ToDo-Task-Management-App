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
    @Query private var todos: [TaskModel] = []
    
    var body: some View {
        VStack {
            HStack {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $text)
                        .textEditorStyle(PlainTextEditorStyle())
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .background(Color.gray.opacity(0.1)) // Background color
                        .frame(height: 100)
                    
                    if text.isEmpty {
                        Text("Write something...")
                            .foregroundColor(Color.gray)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 10)
                    }
                }
                
                Button(action: {
                    if !text.isEmpty {
                        let task = TaskModel(title: text, isCompleted: false, priority: 0)
                        modelContext.insert(task)
                        text = ""
                    }
                }, label: {
                    Text("Save")
                })
            }
            
            List {
                ForEach(Array(todos.enumerated()), id: \.offset) { index, task in
                    HStack {
                        Text("\(index + 1). \(task.title)")
                        
                        Spacer()
                        
                        Button(action: {
                            modelContext.delete(task)
                        }, label: {
                            Image(systemName: "trash.fill")
                                .foregroundColor(Color.red)
                        })
                    }
                }
            }.listStyle(PlainListStyle())
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
