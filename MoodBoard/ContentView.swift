//
//  ContentView.swift
//  MoodBoard
//
//  Created by Yongye Tan on 2/13/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab: AppTabs = .board
    
    var body: some View {
        
        TabView(selection: $selectedTab) {

            Tab(AppTabs.board.name, systemImage: AppTabs.board.systemImage, value: .board) {
                BoardMainLayoutView()
            }
            
            Tab(AppTabs.drawing.name, systemImage: AppTabs.drawing.systemImage, value: .drawing) {
                DrawingView()
            }
        }
        
    }
}

#Preview {
    ContentView()
}
