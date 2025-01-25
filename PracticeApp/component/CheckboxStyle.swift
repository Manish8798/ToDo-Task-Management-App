//
//  CheckboxStyle.swift
//  PracticeApp
//
//  Created by Manish Kumar on 25/01/25.
//

import SwiftUI

// Custom Checkbox Style
struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundColor(configuration.isOn ? .blue : .gray)
            .onTapGesture {
                configuration.isOn.toggle()
            }
    }
}
