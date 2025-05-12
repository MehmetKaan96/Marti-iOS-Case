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
            let region = MKCoordinateRegion(center: location.coordinate,
                                            latitudinalMeters: 100,
                                            longitudinalMeters: 100)
            self?.mainMapView.setRegion(region, animated: true)
        }
    }
}
