//
//  Task.swift
//  PracticeApp
//
//  Created by Manish Kumar on 24/01/25.
//

import Foundation
import SwiftData

@Model
class TaskModel {
    var title: String
    var isCompleted: Bool
    var priority: Int
    
    init(title: String, isCompleted: Bool, priority: Int) {
        self.title = title
        self.isCompleted = isCompleted
        self.priority = priority
    }
    
}
