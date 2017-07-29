//
//  MapVC.swift
//  pixelCity
//
//  Created by Justin Lindsay on 7/29/17.
//  Copyright © 2017 Justin Lindsay. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    // Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
    }
    
    // Actions
    
    @IBAction func centerMapBtnWasPressed(_ sender: Any) {
    }
}

extension MapVC: MKMapViewDelegate {
    
    
}
