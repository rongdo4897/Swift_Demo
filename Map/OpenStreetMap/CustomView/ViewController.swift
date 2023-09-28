//
//  ViewController.swift
//  CustomView
//
//  Created by V002861 on 7/7/22.
//

import UIKit
import MapKit

//MARK: - Outlet, Override
class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblYouLocation: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        customizeComponents()
    }
}

//MARK: - Init
extension ViewController {
    private func initComponents() {
        checkLocationServices()
        initMapView()
        converOSM()
        showCircle(coordinate: CLLocationCoordinate2D(latitude: 21.032011955465766, longitude: 105.7828305655835), radius: 50)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func initMapView() {
        mapView.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    // Tạo 1 lớp phủ và add nó lên mapview
    private func converOSM() {
        let urlOSM = "http://tile.openstreetmap.org/{z}/{x}/{y}.png"
        let overlay = MKTileOverlay(urlTemplate: urlOSM)
        overlay.canReplaceMapContent = true
        mapView.addOverlay(overlay, level: .aboveLabels)
    }
}

//MARK: - Customize
extension ViewController {
    private func customizeComponents() {
        
    }
}

//MARK: - Action - Obj
extension ViewController {
    @objc func willEnterForeground() {
        initMapView()
    }
}

//MARK: - Action
extension ViewController {
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .denied:
                locationOff()
            default:
                break
            }
        } else {
           locationOff()
        }
    }

    func locationOff() {
        AlertUtil.showAlertAskPermission(from: self, with: "Location Services are Off", message: "Turn On Location Services To Allow \"FaceXpress\" to Determine Your Location.") { _ in
            if let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION_SERVICES") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } completionNo: { _ in
            
        }
    }
}

//MARK: - MapViewDelegate
extension ViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    func showCircle(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) {
        let circle = MKCircle(center: coordinate, radius: radius)
        mapView.addOverlay(circle)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKTileOverlay {
            let renderer = MKTileOverlayRenderer(overlay: overlay)
            return renderer
        } else {
            guard let circle = overlay as? MKCircle else { return MKOverlayRenderer() }
            let circleRenderer = MKCircleRenderer(overlay: circle)
            circleRenderer.fillColor = UIColor.colorFromHexString(hex: "CCEDFF")
            circleRenderer.alpha = 0.3
            circleRenderer.lineWidth = 2
            circleRenderer.strokeColor = UIColor.colorFromHexString(hex: "2F80ED")
            return circleRenderer
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            lblYouLocation.text = Double(location.coordinate.latitude).formatCoordinate() + ", " + Double(location.coordinate.longitude).formatCoordinate()
        }
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: locations[0].coordinate, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let userLocation = mapView.view(for: annotation) as? MKPinAnnotationView ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            userLocation.image = UIImage(named: "ic_pegman")
            return userLocation
        } else {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView?.image = UIImage(named: "ic_map_pin")
            return annotationView
        }
    }
}
