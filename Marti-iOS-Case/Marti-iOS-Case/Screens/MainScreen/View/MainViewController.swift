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
    private let mainScreenViewModel = MainScreenViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        self.viewModel = mainScreenViewModel
        configureViewModelCallBack()
        showPinsIfExist()
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = ScreenType.main.rawValue
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "custom-pin")
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}
