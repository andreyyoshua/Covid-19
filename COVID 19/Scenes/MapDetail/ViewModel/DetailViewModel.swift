//
//  DetailViewModel.swift
//  COVID 19
//
//  Created by Andrey Yoshua Manik on 08/03/20.
//  Copyright © 2020 Brid. All rights reserved.
//

import SwiftUI

class DetailViewModel: ObservableObject {
    private let notificationCenter: NotificationCenter = .default
    @Published var keyboardShowing: Bool = false
    var keyword: String = "" {
        didSet {
            filter()
        }
    }

    init() {
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        keyboardShowing = true
    }

    @objc func keyBoardWillHide(notification: Notification) {
        keyboardShowing = false
    }
    
    @Published var details: [DashboardDetail] = []
    var allDetails: [DashboardDetail] = []
    
    private func urlTask<T: Decodable>(urlString: String, type: T.Type, dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ", completion: @escaping((_ data: T, _ response: URLResponse?, _ error: Error?) -> Void)) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                let container = try decoder.singleValueContainer()
                let timeStamp = try container.decode(Int.self) / 1000
                return Date(timeIntervalSince1970: TimeInterval(timeStamp))
            })
            
            guard let decodedData = try? decoder.decode(T.self, from: data) else { return }
            
            DispatchQueue.main.async {
                completion(decodedData, response, error)
            }
        }.resume()
    }
    
    func filter() {
        guard keyword.isEmpty == false else {
            details = allDetails
            return
        }
        details = allDetails.filter({ (detail) -> Bool in
            detail.countryRegion.contains(self.keyword) || (detail.provinceState?.contains(self.keyword) ?? false)
        })
    }
    
    func getDetail(urlString: String) {
        urlTask(urlString: urlString, type: [DashboardDetail].self) { [weak self] (decoded, response, error) in
            self?.details = decoded
            self?.allDetails = decoded
        }
    }
}
