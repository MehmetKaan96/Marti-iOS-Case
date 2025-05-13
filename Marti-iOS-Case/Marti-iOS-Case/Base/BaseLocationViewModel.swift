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
    let screenType: ScreenType
    
    init(screenType: ScreenType) {
        self.screenType = screenType
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidUpdated(_:)), name: .locationDidUpdate, object: nil)
    }
    
    @objc
    private func locationDidUpdated(_ notification: Notification) {
        guard let location = notification.object as? CLLocation else { return }
        
        if locations.isEmpty || (location.distance(from: locations.last!) >= 100) {
            currentLocation = location
            locations.append(location)
            onLocationUpdate?(location)
            
            reverseGeocode(location: location) { address in
                CoreDataManager.saveLocation(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude,
                    address: address,
                    screenType: self.screenType
                )
            }
        }
    }
    
    private func reverseGeocode(location: CLLocation, completion: @escaping (String?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            
            let address = [
                placemark.name,
                placemark.thoroughfare,
                placemark.locality,
                placemark.administrativeArea,
                placemark.country
            ]
                .compactMap { $0 }
                .joined(separator: ", ")
            
            completion(address)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
