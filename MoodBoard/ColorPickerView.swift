//
//  ColorPickerView.swift
//  MoodBoard
//
//  Created by Yongye Tan on 2/14/25.
//

import SwiftUI

struct ColorPickerView: View {
    
    let presetColors: [Color] = [
        .red, .orange, .yellow, 
        .green, .blue, .purple, .pink,
        .indigo
    ]
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 35, maximum: 35), spacing: 12),
        GridItem(.adaptive(minimum: 35, maximum: 35), spacing: 12),
        GridItem(.adaptive(minimum: 35, maximum: 35), spacing: 12),
    ]
    
    @State private var selectedColor: Color? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Colors")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(presetColors, id: \.self) { color in
                    Circle()
                        .fill(color)
                        .frame(width: 35, height: 35)
                        .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
                        .overlay {
                            Circle()
                                .stroke(selectedColor == nil ? Color.clear : Color.blue, lineWidth: 2)
                                .frame(width: 40, height: 40)
                        }
                        .onTapGesture {
                            selectedColor = color
                        }
                    
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}

#Preview {
    ColorPickerView()
        .padding()
}
