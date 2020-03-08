//
//  Detail.swift
//  COVID 19
//
//  Created by Andrey Yoshua Manik on 08/03/20.
//  Copyright © 2020 Brid. All rights reserved.
//

import Foundation

// MARK: - DashboardDetail
struct DashboardDetail: Decodable, Hashable {
    let provinceState: String?
    let countryRegion: String
    let lastUpdate: Date
    let lat, long: Double
    let confirmed, deaths, recovered: Int
}

