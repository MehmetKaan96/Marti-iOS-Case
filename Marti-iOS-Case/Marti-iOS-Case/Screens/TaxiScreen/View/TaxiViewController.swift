//
//  TaxiViewController.swift
//  Marti-iOS-Case
//
//  Created by Mehmet Kaan on 12.05.2025.
//

import UIKit
import MapKit

class TaxiViewController: BaseViewController {
    @IBOutlet weak var taxiMapView: MKMapView!
    private let taxiScreenViewModel = TaxiScreenViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        self.viewModel = taxiScreenViewModel
        configureViewModelCallBack()
        showPinsIfExist()
        drawRouteIfExist()
    }
    
    private func setupMapView() {
        self.mapView = taxiMapView
        taxiMapView.delegate = self
        taxiMapView.showsUserLocation = true
    }
    
    private func configureViewModelCallBack() {
        viewModel.onLocationUpdate = { [weak self] location in
            guard let self = self else { return }
            let region = MKCoordinateRegion(center: location.coordinate,
                                            latitudinalMeters: 500,
                                            longitudinalMeters: 500)
            self.taxiMapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = "Konum \(self.viewModel.locations.count)"
            self.taxiMapView.addAnnotation(annotation)
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
            annotationView?.image = UIImage(named: "taxi")
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .systemGreen
            renderer.lineWidth = 3
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }

}
