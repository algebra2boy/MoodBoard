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
    case image(String) // For now, these images come from assets for demonstration purposes
    
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
        BoardItem(content: .empty)
    ]
    
    var canDraw: Bool {
        switch self.content {
        case .image, .empty:
            return true
        default:
            return false
        }
    }
    
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
    
    func getFirstIndex(of item: BoardItem) -> Int? {
        boardItems.firstIndex(where: { $0.id == item.id })
    }
    
    func createEmptyBoardItem() {
        let newBoardItem: BoardItem = .init(content: .empty)
        self.boardItems.append(newBoardItem)
    }
    
    /// create a text board item with default template
    func createTextBoardItem() {
        let newBoardItem: BoardItem = .init(content: .text(""))
        self.boardItems.append(newBoardItem)
    }
    
    /// Create an image board item using images from `Resources` folder
    func createImageBoardItem() {
        
        guard let resourcePath = Bundle.main.resourcePath else { return }
        
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
            
            /// when we render the image, we just need to provide the imageName, but here `files` returns their full names and file extensions.
            let images = files
                .filter { $0.hasSuffix(".png") || $0.hasSuffix(".jpg") || $0.hasSuffix(".jpeg") }
                .map { ($0 as NSString).deletingPathExtension }
            
            let randomImage = images.randomElement() ?? "smile"
            
            let newBoardItem: BoardItem = .init(content: .image(randomImage))
            self.boardItems.append(newBoardItem)
            
        } catch {
            print("Error loading images: \(error)")
        }
        
    }
    
    func addColor(for item: BoardItem) {
        if let selectedColor {
            if let index = getFirstIndex(of: item) {
                boardItems[index].color = selectedColor
            }
        }
    }
    
    func rearrange(from: IndexSet, to: Int) {
        self.boardItems.move(fromOffsets: from, toOffset: to)
    }
    
    func delete(_ item: BoardItem) {
        self.boardItems = self.boardItems.filter { $0 != item }
    }
}

extension BoardViewModel {
    func binding(for boardItem: BoardItem) -> Binding<BoardItem> {
        guard let index = getFirstIndex(of: boardItem) else {
            fatalError("Board item not found")
        }
        return Binding(
            get: { self.boardItems[index] },
            set: { self.boardItems[index] = $0 }
        )
    }
}
