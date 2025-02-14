//
//  BoardMainLayoutView.swift
//  MoodBoard
//
//  Created by Yongye Tan on 2/13/25.
//

import SwiftUI

struct BoardMainLayoutView: View {
    
    @State private var boardViewModel: BoardViewModel = BoardViewModel()
    
    @State private var presentColorPickerView: Bool = false
    
    let columns: [GridItem] = .init(repeating: .init(.adaptive(minimum: 280, maximum: 350), spacing: 20) , count: 3)
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                LazyVGrid(columns: columns, spacing: 20) {
                    
                    ForEach($boardViewModel.boardItems) { item in
                        boardItemView(for: item)
                    }
                    
                }
                .padding()
            }
            .padding(.vertical, 30)
            .toolbar {
                toolbarButtons
            }
        }
    }
    
    @ViewBuilder
    func boardItemView(for item: Binding<BoardItem>) -> some View {
        Group {
            switch item.wrappedValue.content {
            case .text:
                textView(text: item.textBinding)
            case .image(let string):
                Text("sup image")
            case .empty:
                Text("")
            }
        }
        .frame(width: 280, height: 280)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(item.color.wrappedValue)
        )
        .onTapGesture {
            onTap(item)
        }
        
    }
    
    func onTap(_ item: Binding<BoardItem>) {
        boardViewModel.addColor(for: item.wrappedValue)
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
}
