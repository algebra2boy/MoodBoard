//
//  ReorderableForEach.swift
//  MoodBoard
//
//  Created by Yongye Tan on 2/14/25.

import SwiftUI

// MARK: - Protocol for Reorderable Items
public typealias Reorderable = Identifiable & Equatable

// MARK: - ReorderableForEach
/// Used to enable drag reordering in lazy SwiftUI grids and stacks
public struct ReorderableForEach<Item: Reorderable, Content: View, Preview: View>: View {
    
    typealias ContentBuilder = (Item) -> Content
    typealias PreviewBuilder = (Item) -> Preview
    typealias MoveAction = (IndexSet, Int) -> Void
    
    // Parameters
    private let items: [Item]
    private let content: ContentBuilder
    private let preview: PreviewBuilder?
    private let moveAction: MoveAction
    
    @Binding private var selection: Item?
    
    init(
        _ items: [Item],
        selection: Binding<Item?>,
        @ViewBuilder content: @escaping ContentBuilder,
        @ViewBuilder preview: @escaping PreviewBuilder,
        moveAction: @escaping MoveAction
    ) {
        self.items = items
        self._selection = selection
        self.content = content
        self.preview = preview
        self.moveAction = moveAction
    }
    
    init(
        _ items: [Item],
        selection: Binding<Item?>,
        @ViewBuilder content: @escaping ContentBuilder,
        moveAction: @escaping MoveAction
    ) where Preview == EmptyView {
        self.items = items
        self._selection = selection
        self.content = content
        self.preview = nil
        self.moveAction = moveAction
    }
    
    public var body: some View {
        ForEach(items) { item in
            if let preview {
                contentView(for: item)
                    .onDrag {
                        dragData(for: item)
                    } preview: {
                        preview(item)
                            .previewShape()
                            .transition(.opacity)
                    }
            } else {
                contentView(for: item)
                    .onDrag {
                        dragData(for: item)
                    }
            }
        }
    }
        
    private func contentView(for item: Item) -> some View {
        content(item)
            .onDrop(
                of: [.text],
                delegate: ReorderableDragRelocateDelegate(
                    item: item,
                    items: items,
                    selection: $selection
                ) { from, to in
                    withAnimation {
                        moveAction(from, to)
                    }
                }
            )
            .previewShape()
            .transition(.opacity)
    }
    
    private func dragData(for item: Item) -> NSItemProvider {
        selection = item
        return NSItemProvider(object: "\(item.id)" as NSString)
    }
}

private extension View {
    func previewShape() -> some View {
        contentShape(.dragPreview, RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - Drag Relocate Delegate
fileprivate struct ReorderableDragRelocateDelegate<Item: Reorderable>: DropDelegate {
    
    // Parameters
    let item: Item
    var items: [Item]
    @Binding var selection: Item?
    var moveAction: (IndexSet, Int) -> Void
    
    func dropEntered(info: DropInfo) {
        guard item != selection, let current = selection else { return }
        guard let from = items.firstIndex(of: current) else { return }
        guard let to = items.firstIndex(of: item) else { return }
        if items[to] != current {
            moveAction(IndexSet(integer: from), to > from ? to + 1 : to)
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        selection = nil
        return true
    }
}

fileprivate struct DraggableLazyVGridView: View {
    
    struct GridData: Reorderable {
        let id: Int
    }
    
    @State private var items = (1...20).map { GridData(id: $0) }
    
    @State private var currentActiveItem: GridData?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                ReorderableForEach(items, selection: $currentActiveItem) { item in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue.opacity(0.6))
                        .frame(height: 80)
                        .overlay(Text("\(item.id)").foregroundColor(.white))
                } preview: { item in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.green)
                        .frame(width: 100, height: 100)
                } moveAction: { from, to in
                    items.move(fromOffsets: from, toOffset: to)
                }
            }
            .padding()
        }
    }
}


fileprivate struct DraggableLazyHGridView: View {
    
    struct GridData: Reorderable {
        let id: Int
    }
    
    @State private var items = (1...20).map { GridData(id: $0) }
    
    @State private var currentActiveItem: GridData?
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.fixed(100))]) {
                ReorderableForEach(items, selection: $currentActiveItem) { item in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.green.opacity(0.6))
                        .frame(width: 100)
                        .overlay(Text("\(item.id)").foregroundColor(.white))
                } preview: { item in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.green)
                        .frame(width: 120, height: 120)
                } moveAction: { from, to in
                    items.move(fromOffsets: from, toOffset: to)
                }
            }
            .padding()
        }
        .background(Color.gray.opacity(0.1))
    }
}

// the preview might have some UI glitch for drag and drop. Building and running the app would ensure the best experience
#Preview("lazyHGrid") {
    DraggableLazyHGridView()
}

#Preview("lazyVGrid") {
    DraggableLazyVGridView()
}
