//
//  MainViewController.swift
//  Marti-iOS-Case
//
//  Created by Mehmet Kaan on 12.05.2025.
//

import UIKit
import MapKit

final class MainViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet private weak var mainMapView: MKMapView!
    private let viewModel = MainScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        configureViewModelCallBack()
    }
    
    private func setupMapView() {
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
}
