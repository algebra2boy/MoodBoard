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
    
    // @State variable is a piece of the data that changes over time within a view and causes view re-render if the variable changes
    @State private var selectedTab: AppTabs = .board
    
    @State private var boardViewModel: BoardViewModel = BoardViewModel()

    var body: some View {

        TabView(selection: $selectedTab) {
            
            Tab(AppTabs.board.name, systemImage: AppTabs.board.systemImage, value: .board) {
                BoardMainLayoutView()
            }
           
            Tab(AppTabs.drawing.name, systemImage: AppTabs.drawing.systemImage, value: .drawing) {
                DrawingView()
            }
            .customizationID(AppTabs.drawing.customizationID) // allows us to add/remove the option
        }
        .environment(boardViewModel)
        .tabViewStyle(.sidebarAdaptable) // new starting from iOS 18
        .tabViewCustomization($tabViewCustomization) // new starting from iOS 18

    }
}

#Preview {
    ContentView()
}
