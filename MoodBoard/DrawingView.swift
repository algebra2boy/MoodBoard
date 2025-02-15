//
//  DrawingView.swift
//  MoodBoard
//
//  Created by Yongye Tan on 2/14/25.
//

import SwiftUI
import PencilKit

struct DrawingView: View {
    
    @State private var canvasView = PKCanvasView()
    
    @State private var isToolPickerPresented: Bool = false
    
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
            }
        }
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

#Preview {
    DrawingView()
}
