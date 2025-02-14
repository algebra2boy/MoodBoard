//
//  Tab.swift
//  MoodBoard
//
//  Created by Yongye Tan on 2/13/25.
//

import Foundation

enum AppTabs: String, Equatable, Hashable, Identifiable {
    case board
    case settings
    
    var id: String { self.rawValue }
    
    var name: String { self.rawValue }
    
    var systemImage: String {
        switch self {
        case .board:
            "square.grid.3x3.square"
        case .settings:
            "gear"
        }
    }
    
    var customizationID: String {
        "\(self)"
    }
}
