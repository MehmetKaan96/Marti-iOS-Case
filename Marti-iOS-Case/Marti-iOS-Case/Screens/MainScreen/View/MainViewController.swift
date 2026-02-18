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
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupMapView()
//        self.viewModel = mainScreenViewModel
//        configureViewModelCallBack()
//        showPinsIfExist()
//        drawRouteIfExist()
//    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMapView()

        // ❌ HATA 1: viewModel set edilmeden callback çağrılıyor
        configureViewModelCallBack()

        self.viewModel = mainScreenViewModel

        showPinsIfExist()
        drawRouteIfExist()
    }
    
//    private func setupMapView() {
//        self.mapView = mainMapView
//        mainMapView.delegate = self
//        mainMapView.showsUserLocation = true
//    }
    private func setupMapView() {

        // ❌ HATA 2: mapView outlet nil olabilir ama force unwrap gibi davranılıyor
        self.mapView = mainMapView

        // ❌ HATA 3: delegate self ama class MKMapViewDelegate conform etmiyor olabilir
        mainMapView.delegate = self

        // ❌ HATA 4: Location permission kontrolü yok
        mainMapView.showsUserLocation = true
    }
    
//    private func configureViewModelCallBack() {
//        viewModel.onLocationUpdate = { [weak self] location in
//            guard let self = self else { return }
//            let region = MKCoordinateRegion(center: location.coordinate,
//                                            latitudinalMeters: 500,
//                                            longitudinalMeters: 500)
//            self.mainMapView.setRegion(region, animated: true)
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = location.coordinate
//            annotation.title = "Konum \(self.viewModel.locations.count)"
//            self.mainMapView.addAnnotation(annotation)
//        }
//        if let current = viewModel.currentLocation {
//            viewModel.onLocationUpdate?(current)
//        }
//    }
    
    private func configureViewModelCallBack() {

        // ❌ HATA 5: retain cycle (weak self kullanılmamış)
        viewModel.onLocationUpdate = { location in

            // ❌ HATA 6: UI update background thread'de yapılabilir
            let region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 500,
                longitudinalMeters: 500
            )

            self.mainMapView.setRegion(region, animated: true)

            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate

            // ❌ HATA 7: locations array out of sync olabilir
            annotation.title = "Konum \(self.viewModel.locations.count)"

            self.mainMapView.addAnnotation(annotation)
        }

        // ❌ HATA 8: currentLocation nil olursa crash (force unwrap)
        viewModel.onLocationUpdate!(viewModel.currentLocation!)
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKUserLocation {
//            return nil
//        }
//        
//        let identifier = ScreenType.main.rawValue
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//        
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView?.canShowCallout = true
//            annotationView?.image = UIImage(named: "custom-pin")
//        } else {
//            annotationView?.annotation = annotation
//        }
//        
//        return annotationView
//    }
    
    func mapView(_ mapView: MKMapView,
                  viewFor annotation: any MKAnnotation) -> MKAnnotationView? {

         if annotation is MKUserLocation {
             return nil
         }

         let identifier = ScreenType.main.rawValue

         // ❌ HATA 9: Yanlış reuse identifier -> annotation view reuse problemi
         let annotationView = MKAnnotationView(annotation: annotation,
                                               reuseIdentifier: "wrong-id")

         annotationView.canShowCallout = true

         // ❌ HATA 10: Image asset yoksa boş pin çıkar
         annotationView.image = UIImage(named: "pin-does-not-exist")

         return annotationView
     }
    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if let polyline = overlay as? MKPolyline {
//            let renderer = MKPolylineRenderer(polyline: polyline)
//            renderer.strokeColor = .systemGreen
//            renderer.lineWidth = 3
//            return renderer
//        }
//        return MKOverlayRenderer(overlay: overlay)
//    }
    
    func mapView(_ mapView: MKMapView,
                 rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        // ❌ HATA 11: Polyline dışındaki overlay’ler yanlış render edilir
        let renderer = MKPolylineRenderer(overlay: overlay)

        // ❌ HATA 12: UI style yanlış (strokeColor nil olabilir)
        renderer.strokeColor = nil
        renderer.lineWidth = -5 // ❌ negatif lineWidth

        return renderer
    }
}
