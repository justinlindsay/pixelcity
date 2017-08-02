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

class MapVC: UIViewController, UIGestureRecognizerDelegate {

    // Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var pullUpView: UIView!
    
    // Variables
    
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    var screenSize = UIScreen.main.bounds
    var spinner: UIActivityIndicatorView?
    var progressLbl: UILabel?
    
    // Functions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        configureLocationServices()
        addDoubleTap()
        
    }
    
    func addDoubleTap() {
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(sender:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
        
    }
    
    func removePin() {
        
        for annotation in mapView.annotations {
            
            mapView.removeAnnotation(annotation)
        
        }
    }
    
    func addSwipe() {
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animateViewDown))
        swipe.direction = .down
        pullUpView.addGestureRecognizer(swipe)
        
    }
    
    func animateViewUp() {
        
        mapViewBottomConstraint.constant = 300
        UIView.animate(withDuration: 0.3) {
            
            self.view.layoutIfNeeded()
            
        }
    }
    
    func addSpinner() {
        
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: (screenSize.width / 2) - ((spinner?.frame.width)! / 2), y: 150)
        spinner?.activityIndicatorViewStyle = .whiteLarge
        spinner?.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        spinner?.startAnimating()
        pullUpView.addSubview(spinner!)
        
    }
    
    @objc func dropPin(sender: UITapGestureRecognizer) {
        
        removePin()
        animateViewUp()
        addSwipe()
        addSpinner()
        
        let touchPoint = sender.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let annotation = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        mapView.addAnnotation(annotation)
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(touchCoordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    @objc func animateViewDown() {
        
        mapViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            
            self.view.layoutIfNeeded()
            
        }
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            
            return nil
            
        }
        
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
        pinAnnotation.pinTintColor = #colorLiteral(red: 0.9771530032, green: 0.7062081099, blue: 0.1748393774, alpha: 1)
        pinAnnotation.animatesDrop = true
        return pinAnnotation
        
    }
    
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
