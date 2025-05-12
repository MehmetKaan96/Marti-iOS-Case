//
//  BaseLocationViewModel.swift
//  Marti-iOS-Case
//
//  Created by Mehmet Kaan on 13.05.2025.
//

import Foundation
import CoreLocation

class BaseLocationViewModel {
    var currentLocation: CLLocation?
    var onLocationUpdate: ((CLLocation) -> Void)?
    private(set) var locations: [CLLocation] = []
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidUpdated(_:)), name: .locationDidUpdate, object: nil)
    }
    
    @objc
    private func locationDidUpdated(_ notification: Notification) {
        guard let location = notification.object as? CLLocation else { return }
        
        if locations.isEmpty || (location.distance(from: locations.last!) >= 100) {
            currentLocation = location
            locations.append(location)
            onLocationUpdate?(location)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
