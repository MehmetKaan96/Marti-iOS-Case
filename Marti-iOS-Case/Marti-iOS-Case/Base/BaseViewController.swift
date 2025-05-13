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
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        stack.distribution = .fillEqually
        return stack
    }()
    
    private var isTracking = true
    var viewModel: BaseLocationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
        setupToggleButton()
        setupResetButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = containerView.frame.height / 2
    }
    
    private func setupContainerView() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            containerView.heightAnchor.constraint(equalToConstant: 44)
        ])

        containerView.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])

        buttonStackView.addArrangedSubview(resetButton)
        buttonStackView.addArrangedSubview(toggleButton)
    }
    
    private func setupToggleButton() {
        toggleButton.setTitle("Durdur", for: .normal)
        toggleButton.setTitleColor(.label, for: .normal)
        toggleButton.addTarget(self, action: #selector(toggleLocationTracking), for: .touchUpInside)
    }
    
    private func setupResetButton() {
        resetButton.setTitle("Rotayı Sıfırla", for: .normal)
        resetButton.setTitleColor(.label, for: .normal)
        resetButton.addTarget(self, action: #selector(resetRoute), for: .touchUpInside)
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
