//
//  ColorPickerView.swift
//  MoodBoard
//
//  Created by Yongye Tan on 2/14/25.
//

import SwiftUI

struct ColorPickerView: View {
    
    let presetColors: [Color] = [.red, .green, .yellow, .blue, .purple, .orange, .pink]
    
    let columns: [GridItem] = .init(repeating: .init(.flexible(minimum: 20, maximum:40)), count: 2)
    
    var body: some View {
        
        VStack {
            
            LazyVGrid(columns: columns, spacing: 10) {
                
                ForEach(presetColors, id: \.self) { color in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(color)
                        .frame(width: 50, height: 50)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var show: Bool = true
    Button {
        show.toggle()
    } label:  {
        Text("Tap on")
    }
    .popover(isPresented: $show) {
        ColorPickerView()
    }
}
