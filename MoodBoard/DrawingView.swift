//
//  DrawingView.swift
//  MoodBoard
//
//  Created by Yongye Tan on 2/14/25.
//

import SwiftUI
import PencilKit

struct DrawingView: View {
    
    @Environment(BoardViewModel.self) private var boardViewModel
    
    @State private var canvasView = PKCanvasView()
    
    @State private var isToolPickerPresented: Bool = false
    
    @State private var isalertShown: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                CanvasView(canvasView: $canvasView, isToolPickerPresented: $isToolPickerPresented)
                    .border(Color.black.opacity(0.5), width: 2)
            }
            .padding()
            .navigationTitle("Drawing View")
            .toolbar {
                ToolbarItem {
                    Button {
                        isToolPickerPresented.toggle()
                    } label: {
                        Image(systemName: "pencil.and.scribble")
                    }
                }
                
                ToolbarItem {
                    Button {
                        isalertShown.toggle()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                }
            }
            .alert("This will create a new board item with the current drawing", isPresented: $isalertShown) {
                Button(role: .cancel, action: { }, label: { Text("Cancel") })
                Button(action: create, label: { Text("Yes!") })
            }
        }
    }
    
    func create() {
        let snapshot = CanvasView(canvasView: $canvasView, isToolPickerPresented: $isToolPickerPresented)
            .frame(width: 1440, height: 1680)
            .snapshot()
        boardViewModel.createDrawingBoardItem(with: snapshot)
    }
}

struct CanvasView: UIViewRepresentable {
    
    @Binding var canvasView: PKCanvasView
    
    @Binding var isToolPickerPresented: Bool
    
    let toolPicker = PKToolPicker.init()
    
    func makeUIView(context: Context) -> PKCanvasView {
        
        canvasView.drawingPolicy = .anyInput // .pencilOnly is another option
        
        // make the canvas first responder so it can display the tool picker
        canvasView.becomeFirstResponder()
        
        return canvasView
    }
    
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // update the tool picker visibility
        if isToolPickerPresented {
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            toolPicker.addObserver(canvasView)
        } else {
            toolPicker.setVisible(false, forFirstResponder: canvasView)
            toolPicker.removeObserver(canvasView)
        }
    }
    
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

#Preview {
    DrawingView()
        .environment(BoardViewModel())
}
