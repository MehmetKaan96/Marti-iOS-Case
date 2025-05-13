//
//  TagViewController.swift
//  Marti-iOS-Case
//
//  Created by Mehmet Kaan on 12.05.2025.
//

import UIKit
import MapKit

class TagViewController: BaseViewController {

    @IBOutlet weak var tagMapView: MKMapView!
    private let tagScreenViewModel = TagScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        self.viewModel = tagScreenViewModel
        configureViewModelCallBack()
        showPinsIfExist()
    }
    
    private func setupMapView() {
        self.mapView = tagMapView
        tagMapView.delegate = self
        tagMapView.showsUserLocation = true
    }
    
    private func configureViewModelCallBack() {
        viewModel.onLocationUpdate = { [weak self] location in
            guard let self = self else { return }
            let region = MKCoordinateRegion(center: location.coordinate,
                                            latitudinalMeters: 500,
                                            longitudinalMeters: 500)
            self.tagMapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = "Konum \(self.viewModel.locations.count)"
            self.tagMapView.addAnnotation(annotation)
        }
    }
}
