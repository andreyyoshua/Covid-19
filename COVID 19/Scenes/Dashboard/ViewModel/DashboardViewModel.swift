//
//  DashboardViewModel.swift
//  COVID 19
//
//  Created by Andrey Yoshua Manik on 08/03/20.
//  Copyright © 2020 Brid. All rights reserved.
//

import Foundation

class DashboardViewModel: ObservableObject {
    @Published var confirmedCase = DashboardData(value: 0, detail: "")
    @Published var recoveredCase = DashboardData(value: 0, detail: "")
    @Published var deathCase = DashboardData(value: 0, detail: "")
    
    @Published var details: [DashboardDetail] = []
    
    @Published var daily: [DashboardDaily] = []
    
    private func urlTask<T: Decodable>(urlString: String, type: T.Type, dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ", completion: @escaping((_ data: T, _ response: URLResponse?, _ error: Error?) -> Void)) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                let container = try decoder.singleValueContainer()
                let dateStr = try container.decode(String.self)
                let formatter = DateFormatter()
                formatter.dateFormat = dateFormat
                guard let date = formatter.date(from: dateStr) else {
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
                }
                return date
            })
            
            guard let decodedData = try? decoder.decode(T.self, from: data) else { return }
            
            DispatchQueue.main.async {
                completion(decodedData, response, error)
            }
        }.resume()
    }
    
    func getData() {
        urlTask(urlString: "https://covid19.mathdro.id/api", type: Dashboard.self) { [weak self] (decoded, response, error) in
            self?.confirmedCase = decoded.confirmed
            self?.recoveredCase = decoded.recovered
            self?.deathCase = decoded.deaths
        }
    }
    
    func getDetail(urlString: String) {
        urlTask(urlString: urlString, type: [DashboardDetail].self) { [weak self] (decoded, response, error) in
            self?.details = decoded
        }
    }
    
    func getDaily() {
        urlTask(urlString: "https://covid19.mathdro.id/api/daily", type: [DashboardDaily].self, dateFormat: "yyyy/MM/dd") { [weak self] (decoded, response, error) in
            self?.daily = decoded
        }
    }
}
