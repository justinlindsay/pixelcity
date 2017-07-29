//
//  MapVC.swift
//  pixelCity
//
//  Created by Justin Lindsay on 7/29/17.
//  Copyright © 2017 Justin Lindsay. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {

    // Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // Variables
    
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        configureLocationServices()
        
    }
    
    // Actions
    
    @IBAction func centerMapBtnWasPressed(_ sender: Any) {
        
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            
            centerMapOnUserLocation()
            
        }
    }
    
    
}

// Extensions

extension MapVC: MKMapViewDelegate {
    
    func centerMapOnUserLocation() {
        
        guard let coordinate = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
}

extension MapVC: CLLocationManagerDelegate {
    
    func configureLocationServices() {
        
        if authorizationStatus == .notDetermined {
            
            locationManager.requestAlwaysAuthorization()
            
        } else {
            
            return
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        centerMapOnUserLocation()
        
    }
}
