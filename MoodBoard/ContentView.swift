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
    
    var body: some View {
        
        TabView(selection: $selectedTab) {

            Tab(AppTabs.board.name, systemImage: AppTabs.board.systemImage, value: .board) {
                BoardMainLayoutView()
            }
            
            Tab(AppTabs.settings.name, systemImage: AppTabs.settings.systemImage, value: .settings) {
                Text("settings")
            }
            .customizationID(AppTabs.settings.customizationID)
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabViewCustomization($tabViewCustomization)
        
    }
}

#Preview {
    ContentView()
}
