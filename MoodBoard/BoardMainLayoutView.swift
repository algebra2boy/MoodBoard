//
//  BoardMainLayoutView.swift
//  MoodBoard
//
//  Created by Yongye Tan on 2/13/25.
//

import SwiftUI

struct BoardMainLayoutView: View {
    
    @State private var boardViewModel: BoardViewModel = BoardViewModel()
    
    let columns: [GridItem] = .init(repeating: .init(.adaptive(minimum: 280, maximum: 350), spacing: 20) , count: 3)
    
    var body: some View {
        
        NavigationStack {
            
            LazyVGrid(columns: columns, spacing: 20) {
                
                ForEach(boardViewModel.boardItems) { item in
                    boardItemView(for: item)
                }
                
            }
            .padding()
            .toolbar {
                toolbarButtons
            }
        }
    }
    
    @ViewBuilder
    func boardItemView(for item: BoardItem) -> some View {
        Group {
            switch item.content {
            case .text(let string):
                textView(text: string)
            case .image(let string):
                Text("sup image")
            case .empty:
                Text("")
            }
        }
        .frame(width: 280, height: 280)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.2))
        )
    }
    
    func textView(text: String) -> some View {
        Text("\(text)")
    }
    
    var toolbarButtons: some ToolbarContent {
        ToolbarItemGroup {
            Button {
                boardViewModel.createTextBoardItem()
            } label: {
                Image(systemName: "t.square")
                    .font(.system(size: 25))
            }
            
            Button {
                
            } label: {
                Image(systemName: "photo")
                    .font(.system(size: 25))
            }
            
            Button {
                
            } label: {
                Image(systemName: "paintpalette")
                    .font(.system(size: 25))
            }
            
            
        }
    }
}

#Preview {
    BoardMainLayoutView()
}
