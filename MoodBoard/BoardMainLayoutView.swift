//
//  BoardMainLayoutView.swift
//  MoodBoard
//
//  Created by Yongye Tan on 2/13/25.
//

import SwiftUI

struct BoardMainLayoutView: View {
    
    let columns: [GridItem] = .init(repeating: .init(.adaptive(minimum: 280, maximum: 350), spacing: 10) , count: 3)
        
    var body: some View {
        
        NavigationStack {
            
            LazyVGrid(columns: columns) {
                
                ForEach(1...3, id: \.self) { text in
                    Text("\(text)")
                        .frame(width: 280, height: 280)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.2))
                        )
                }
                
            }
            .padding()
            .toolbar {
                toolbarButtons
            }
        }
    }
    
    var toolbarButtons: some ToolbarContent {
        ToolbarItemGroup {
            Button {
                
            } label: {
                Image(systemName: "t.square")
                    .font(.system(size: 25))
            }
            
            Button {
                
            } label: {
                Image(systemName: "photo")
                    .font(.system(size: 25))
            }
            
            
        }
    }
}

#Preview {
    BoardMainLayoutView()
}
