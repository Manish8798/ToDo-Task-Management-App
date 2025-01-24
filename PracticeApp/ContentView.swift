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
                        .frame(height: 50)
                    
                    if text.isEmpty {
                        Text("Write something...")
                            .padding()
                            .foregroundColor(Color.gray)
                    }
                }
                
                Button(action: {
                    if !text.isEmpty {
                        let task = TaskModel(title: text, isCompleted: false, pripority: 0)
                        modelContext.insert(task)
                        text = ""
                    }
                }, label: {
                    Text("Save")
                })
            }
            
            List(todos) { task in
                HStack{
                    Text(task.title)
                    
                    Spacer()
                    
                    Button(action: {
                        modelContext.delete(task)
                    }, label: {
                        Image(systemName: "trash.fill")
                            .foregroundColor(Color.red)
                    })
                    
                }
                
            }.listStyle(PlainListStyle())
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
