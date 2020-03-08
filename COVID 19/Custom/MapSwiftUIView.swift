//
//  MapSwiftUIView.swift
//  COVID 19
//
//  Created by Andrey Yoshua Manik on 08/03/20.
//  Copyright © 2020 Brid. All rights reserved.
//

import SwiftUI
import MapKit

struct MapSwiftUIView: UIViewRepresentable {
    @Binding var locations: [[Double]]
    var annotationHandler: MapAnnotationView
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self.annotationHandler
        return mapView
    }
    
    func updateUIView(_ map: MKMapView, context: Context) {
        map.removeAnnotations(map.annotations)
        locations.forEach { (location) in
            guard let lat = location.first, let long = location.last else { return }
            let ann = MKPointAnnotation()
            ann.coordinate = CLLocationCoordinate2DMake(lat, long)
            map.addAnnotation(ann)
        }
        map.showAnnotations(map.annotations, animated: true)
    }
}

class MapAnnotationView: NSObject, MKMapViewDelegate {
    
    private var dashboardCase: DashboardEnum = .infected
    
    init(dashboardCase: DashboardEnum = .infected) {
        self.dashboardCase = dashboardCase
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        annotationView.markerTintColor = self.dashboardCase.backgroundColor.uiColor
        return annotationView
    }
}

class MapLocationManager: NSObject, CLLocationManagerDelegate {

    private var locationManager = CLLocationManager()
    private let locationCallback: (CLLocation) -> Void
    
    init(callback: @escaping (CLLocation) -> Void) {
        self.locationCallback = callback
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
}
