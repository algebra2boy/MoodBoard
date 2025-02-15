//
//  ContentView.swift
//  MoodBoard
//
//  Created by Yongye Tan on 2/13/25.
//

import SwiftUI

struct ContentView: View {

    // a way to persist small and simple data in the disk
    @AppStorage("sidebarCustomizations") var tabViewCustomization: TabViewCustomization
    
    @State private var selectedTab: AppTabs = .board
    
    @State private var boardViewModel: BoardViewModel = BoardViewModel()

    var body: some View {

        TabView(selection: $selectedTab) {
            
            Tab(AppTabs.board.name, systemImage: AppTabs.board.systemImage, value: .drawing) {
                BoardMainLayoutView()
            }
            .customizationID(AppTabs.board.customizationID)

           
            Tab(AppTabs.drawing.name, systemImage: AppTabs.drawing.systemImage, value: .drawing) {
                DrawingView()
            }
            .customizationID(AppTabs.drawing.customizationID)
        }
        .environment(boardViewModel)
        .tabViewStyle(.sidebarAdaptable)
        .tabViewCustomization($tabViewCustomization)

    }
}

#Preview {
    ContentView()
}
