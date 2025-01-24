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
    var pripority: Int
    
    init(title: String, isCompleted: Bool, pripority: Int) {
        self.title = title
        self.isCompleted = isCompleted
        self.pripority = pripority
    }
    
}
