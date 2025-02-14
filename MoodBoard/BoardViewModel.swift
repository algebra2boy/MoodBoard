//
//  BoardViewModel.swift
//  MoodBoard
//
//  Created by Yongye Tan on 2/13/25.
//

import Foundation
import SwiftUI

enum BoardContent: Hashable {
    
    /// accept a text to display on screen
    case text(String)
    
    /// accept an image to display on screen
    case image(String) // URL or asset name
    
    case empty
    
}

struct BoardItem: Identifiable, Hashable {
    
    let id: UUID = UUID()
    var content: BoardContent
    var color: Color
    
    init(content: BoardContent, Color: Color? = nil) {
        self.content = content
        self.color = .gray.opacity(0.2)
    }
    
    static let example: [Self] = [
        BoardItem(content: .text("Hello, how are you doing")),
        BoardItem(content: .image("sample_image")),
        BoardItem(content: .empty)
    ]
    
}

@Observable class BoardViewModel {
    
    var boardItems: [BoardItem] = []
    
    var selectedColor: Color? = nil
    
    init() {
        setup()
    }
    
    /// add three default board items to play around
    func setup() {
        self.boardItems = BoardItem.example
    }
    
    /// create a text board item with default template
    func createTextBoardItem() {
        let newBoardItem: BoardItem = .init(content: .text("Add your text here..."))
        self.boardItems.append(newBoardItem)
    }
    
    func addColor(for item: BoardItem) {
        if let selectedColor {
            if let index = boardItems.firstIndex(where: { $0.id == item.id }) {
                boardItems[index].color = selectedColor
            }
        }
    }
    
    func rearrange(from: IndexSet, to: Int) {
        self.boardItems.move(fromOffsets: from, toOffset: to)
    }
}

extension BoardViewModel {
    func binding(for boardItem: BoardItem) -> Binding<BoardItem> {
        guard let index = boardItems.firstIndex(where: { $0.id == boardItem.id }) else {
            fatalError("Board item not found")
        }
        return Binding(
            get: { self.boardItems[index] },
            set: { self.boardItems[index] = $0 }
        )
    }
}
