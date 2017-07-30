//
//  DroppablePin.swift
//  pixelCity
//
//  Created by Justin Lindsay on 7/29/17.
//  Copyright © 2017 Justin Lindsay. All rights reserved.
//

import UIKit
import MapKit

class DroppablePin: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var identifier: String
    
    init(coordinate: CLLocationCoordinate2D, identifier: String) {
        
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
        
    }
    
}
