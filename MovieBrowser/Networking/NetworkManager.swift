//
//  NetworkManager.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 02.10.2020.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    private var isListening: Bool
    private let manager: NetworkReachabilityManager?
    var isReachable: Bool {
        return manager?.isReachable ?? false
    }
    private var statusObservers: [(NetworkReachabilityManager.NetworkReachabilityStatus) -> Void] = []
    
    private init() {
        isListening = false
        manager = NetworkReachabilityManager.default
        startListeningForNetworkChanges()
    }
    
    func observeNetworkStatus(block: @escaping (NetworkReachabilityManager.NetworkReachabilityStatus) -> Void) {
        statusObservers.append(block)
    }
    
    private func startListeningForNetworkChanges() {
        manager?.startListening(onUpdatePerforming: { [weak self] (status) in
            print("NETWORK STATUS -> \(status)")
            self?.notify(status: status)
        })
    }
    
    private func notify(status: NetworkReachabilityManager.NetworkReachabilityStatus) {
        statusObservers.forEach { (observer) in
            observer(status)
        }
    }
}
