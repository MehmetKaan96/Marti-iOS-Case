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
    private let resetButton = UIButton(type: .system)
    private var isTracking = true
    var viewModel: BaseLocationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToggleButton()
        setupResetButton()
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
    
    private func setupResetButton() {
        resetButton.setTitle("Rotayı Sıfırla", for: .normal)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.addTarget(self, action: #selector(resetRoute), for: .touchUpInside)

        view.addSubview(resetButton)
        NSLayoutConstraint.activate([
            resetButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
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
    
    @objc private func resetRoute() {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        CoreDataManager.deleteLocations(for: viewModel.screenType)
        viewModel.resetLocations()
    }
    
    func showPinsIfExist() {
        let pins = CoreDataManager.fetchLocations(for: viewModel.screenType)
        guard !pins.isEmpty else { return }
        
        for pin in pins {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            annotation.title = pin.address ?? "Konum"
            mapView.addAnnotation(annotation)
        }
    }
    
    func drawRouteIfExist() {
        let pins = CoreDataManager.fetchLocations(for: viewModel.screenType)
        guard pins.count >= 2 else { return }
        
        let coordinates = pins.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
    }
}
