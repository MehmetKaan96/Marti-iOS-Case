//
//  MainViewController.swift
//  Marti-iOS-Case
//
//  Created by Mehmet Kaan on 12.05.2025.
//

import UIKit
import MapKit

final class MainViewController: BaseViewController {
    @IBOutlet private weak var mainMapView: MKMapView!
    private let viewModel = MainScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        showPinsIfExist()
        configureViewModelCallBack()
    }
    
    private func setupMapView() {
        self.mapView = mainMapView
        mainMapView.delegate = self
        mainMapView.showsUserLocation = true
    }
    
    private func configureViewModelCallBack() {
        viewModel.onLocationUpdate = { [weak self] location in
            guard let self = self else { return }
            let region = MKCoordinateRegion(center: location.coordinate,
                                            latitudinalMeters: 500,
                                            longitudinalMeters: 500)
            self.mainMapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = "Konum \(self.viewModel.locations.count)"
            self.mainMapView.addAnnotation(annotation)
        }
    }
    
    private func showPinsIfExist() {
        let pins = CoreDataManager.fetchLocations(for: .main)
        guard !pins.isEmpty else { return }
        
        for pin in pins {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            annotation.title = pin.address ?? "Konum"
            mapView.addAnnotation(annotation)
        }
    }
}
