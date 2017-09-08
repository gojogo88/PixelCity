//
//  DroppablePin.swift
//  pixelCity
//
//  Created by Jonathan Go on 2017/09/08.
//  Copyright © 2017 Appdelight. All rights reserved.
//

import UIKit
import MapKit

//custom subclass of MKAnnotation - to drop the pin
class DroppablePin: NSObject, MKAnnotation {   //we need these 2 if we want to use a drop pin
    var coordinate: CLLocationCoordinate2D
    var identifier: String
    
    init(coordinate: CLLocationCoordinate2D, identifier: String) {
        self.coordinate = coordinate
        self.identifier = identifier  //we set the identifier in out class equal to the identifer we set during initialization
        super.init()  //allows us to use this as an initializer for our custom pin. BUT, the coordinate cannot be properly set unless its a dynamic variable
    }
}
