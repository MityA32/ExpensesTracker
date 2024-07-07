//
//  NetworkMonitor.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 08.07.2024.
//

import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private(set) var isConnected: Bool = false
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            NotificationCenter.default.post(name: .networkStatusChanged, object: nil)
        }
        monitor.start(queue: queue)
    }
}

extension Notification.Name {
    static let networkStatusChanged = Notification.Name("networkStatusChanged")
}
