//
//  BoardMainLayoutView.swift
//  MoodBoard
//
//  Created by Yongye Tan on 2/13/25.
//

import SwiftUI

struct BoardMainLayoutView: View {
    
    @Environment(BoardViewModel.self) private var boardViewModel
    
    @State private var presentColorPickerView: Bool = false
    
    let columns: [GridItem] = .init(repeating: .init(.adaptive(minimum: 280, maximum: 350), spacing: 20) , count: 3)
    
    @State private var currentBoard: BoardItem?
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                LazyVGrid(columns: columns, spacing: 20) {
                    
                    ReorderableForEach(boardViewModel.boardItems, selection: $currentBoard) { item in
                        boardItemView(for: item)
                    } preview: { item in
                        boardItemView(for: item)
                    } moveAction: { from, to in
                        boardViewModel.rearrange(from: from, to: to)
                    }
                    
                }
                .padding()
            }
            .navigationTitle("Board View")
            .padding(.vertical, 30)
            .toolbar {
                toolbarButtons
            }
        }
    }
    
    @ViewBuilder
    func boardItemView(for item: BoardItem) -> some View {
        let bindingItem = boardViewModel.binding(for: item)
        
        Group {
            switch item.content {
            case .text:
                textView(text: bindingItem.textBinding)
            case .image(let string):
                imageView(imageName: string)
            case .drawing(let image):
                drawingView(image)
            case .empty:
                Text("")
            }
        }
        .frame(width: 280, height: 280)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(item.color)
        )
        .onTapGesture {
            onTap(bindingItem)
        }
        .contextMenu {
            
            Button(role: .destructive) {
                if currentBoard == item { // deselect currentBoard if we delete
                    currentBoard = nil
                }
                
                boardViewModel.delete(item)
            } label: {
                Label("Delete", systemImage: "trash")
            }
            
        }
        
    }
    
    /// only adds color to text, empty grid
    func onTap(_ item: Binding<BoardItem>) {
        switch item.wrappedValue.content {
        case .text, .empty:
            boardViewModel.addColor(for: item.wrappedValue)
        default:
            return
        }
    }
    
    func textView(text: Binding<String>) -> some View {
        VStack {
            TextField("Add your text here...", text: text, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.leading)
                .keyboardType(.default)
                .padding()
        }
    }
    
    @ViewBuilder
    func imageView(imageName: String) -> some View {
        GeometryReader { geoReader in
            if let uiImage = loadImageFromBundle(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geoReader.size.width, height: geoReader.size.height) // dynamically adjust dimension instead of hardcoding using the width and height from the parent board item dimension
                    .clipped() // avoid the image extend beyond the board item's bounds
            } else {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geoReader.size.width, height: geoReader.size.height)
                    .clipped()
            }
        }
    }
    
    func drawingView(_ image: UIImage) -> some View {
        GeometryReader { geoReader in
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: geoReader.size.width, height: geoReader.size.height)
                .clipped()
        }
    }
    
    func loadImageFromBundle(named name: String) -> UIImage? {
        let fileExtensions = ["png", "jpg", "jpeg"]
        for fileExtension in fileExtensions {
            if let path = Bundle.main.path(forResource: name, ofType: fileExtension) {
                return UIImage(contentsOfFile: path)
            }
        }
        return nil
    }
    
    var toolbarButtons: some ToolbarContent {
        ToolbarItemGroup {
            
            Button {
                boardViewModel.createEmptyBoardItem()
            } label: {
                Image(systemName: "square")
                    .font(.system(size: 25))
            }
            
            Button {
                boardViewModel.createTextBoardItem()
            } label: {
                Image(systemName: "t.square")
                    .font(.system(size: 25))
            }
            
            Button {
                boardViewModel.createImageBoardItem()
            } label: {
                Image(systemName: "photo")
                    .font(.system(size: 25))
            }
            
            Button {
                presentColorPickerView.toggle()
            } label: {
                Image(systemName: "paintpalette")
                    .font(.system(size: 25))
            }
            .popover(isPresented: $presentColorPickerView) {
                ColorPickerView()
                    .environment(boardViewModel)
            }
            
        }
    }
}

extension Binding where Value == BoardItem {
    var textBinding: Binding<String> {
        Binding<String>(
            get: {
                // Safely extract the associated text; if not text, return an empty string.
                if case let .text(text) = self.wrappedValue.content {
                    return text
                }
                return ""
            },
            set: { newValue in
                // only update if the current content is .text
                if case .text = self.wrappedValue.content {
                    self.wrappedValue.content = .text(newValue)
                }
            }
        )
    }
}


#Preview {
    BoardMainLayoutView()
        .environment(BoardViewModel())
}
