//
//  BoardViewModel.swift
//  MoodBoard
//
//  Created by Yongye Tan on 2/13/25.
//

import Foundation

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
    
    static let example: [Self] = [
        BoardItem(content: .text("Hello, how are you doing")),
        BoardItem(content: .image("sample_image")),
        BoardItem(content: .empty)
    ]
    
}

@Observable class BoardViewModel {
    
    var boardItems: [BoardItem] = []
    
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
}
