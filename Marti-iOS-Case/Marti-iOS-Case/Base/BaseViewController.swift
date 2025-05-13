//
//  BaseViewController.swift
//  Marti-iOS-Case
//
//  Created by Mehmet Kaan on 13.05.2025.
//

import Foundation
import UIKit
import MapKit

class BaseViewController: UIViewController, MKMapViewDelegate {
    var mapView: MKMapView!
    private let toggleButton = UIButton(type: .system)
    private var isTracking = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToggleButton()
    }
    
    private func setupToggleButton() {
        toggleButton.setTitle("Durdur", for: .normal)
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.addTarget(self, action: #selector(toggleLocationTracking), for: .touchUpInside)
        
        view.addSubview(toggleButton)
        NSLayoutConstraint.activate([
            toggleButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            toggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func toggleLocationTracking() {
        isTracking.toggle()
        toggleButton.setTitle(isTracking ? "Durdur" : "Başlat", for: .normal)
        if isTracking {
            LocationManager.shared.startUpdating()
        } else {
            LocationManager.shared.stopUpdating()
        }
    }
    
}
