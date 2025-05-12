//
//  MainScreenViewModel.swift
//  Marti-iOS-Case
//
//  Created by Mehmet Kaan on 12.05.2025.
//

import Foundation
import CoreLocation

final class MainScreenViewModel {
    var currentLocation: CLLocation?
    var onLocationUpdate: ((CLLocation) -> Void)?
    
    
    init () {
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidUpdated(_:)), name: .locationDidUpdate, object: nil)
    }
    
    @objc
    func locationDidUpdated(_ notification: Notification) {
        guard let location = notification.object as? CLLocation else { return }
        self.currentLocation = location
        onLocationUpdate?(location)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
