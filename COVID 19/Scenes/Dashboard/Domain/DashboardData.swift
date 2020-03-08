//
//  DashboardData.swift
//  COVID 19
//
//  Created by Andrey Yoshua Manik on 08/03/20.
//  Copyright © 2020 Brid. All rights reserved.
//

import SwiftUI

// MARK: - DashboardData
struct Dashboard: Decodable {
    let confirmed, recovered, deaths: DashboardData
    let daily, image, source: String
    let lastUpdate: Date
}

// MARK: - Confirmed
struct DashboardData: Decodable {
    let value: Int
    let detail: String
}

// MARK: - DashboardDaily
struct DashboardDaily: Decodable, Hashable {
    let reportDate, mainlandChina, otherLocations, totalConfirmed: Int
    let totalRecovered: Int?
    let reportDateString: Date
    let deltaConfirmed: Int
    let deltaRecovered: Int?
    let objectid: Int
}


// MARK: - Dashboard Enum
enum DashboardEnum: String, CaseIterable {
    case infected = "infected cases"
    case recovered = "recovered cases"
    case death = "death cases"
    
    var backgroundColor: Color {
        switch self {
        case .infected: return Color(hex: 0xbfb500) // Yellow
        case .recovered: return Color(hex: 0x45c229) // Green
        case .death: return Color(hex: 0xe62e2e) // Red
        }
    }
    
    var textColor: Color {
        switch self {
        case .infected: return .white
        case .recovered: return .white
        case .death: return .white
        }
    }
}

