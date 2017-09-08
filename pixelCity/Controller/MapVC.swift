//
//  ViewController.swift
//  pixelCity
//
//  Created by Jonathan Go on 2017/09/08.
//  Copyright © 2017 Appdelight. All rights reserved.
//

import UIKit
import Alamofire
import MapKit
import CoreLocation

class MapVC: UIViewController, UIGestureRecognizerDelegate {
    
    //Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    //variables
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()  //will keep track of that auth status
    let regionRadius : Double = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        locationManager.delegate = self
        configureLocationServices()
        addDoubleTap()
    }
    
    func addDoubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(sender:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)  //adding this func to the mapview to allow double tap
    }

    @IBAction func centerMapBtnPressed(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMapOnUserLocation()
        }
    }
}

extension MapVC: MKMapViewDelegate {
    
    //custom color for pin
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
        //we use guard let bec location manager might be slow when the app opens up (mapview might now be loaded yet).
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func removePin() {  //so only 1 pin shows at a time.
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)  //blue dot is an annotation and is called and shown by default
        }
    }
    
    @objc func dropPin(sender: UITapGestureRecognizer) {
        removePin()
        //print("Pin was dropped")
        let touchPoint = sender.location(in: mapView)  //print out our touchpoint coordinates of the SCREEN (not gps)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)  //converts it to gps coordinate
        
        let annotation = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        mapView.addAnnotation(annotation)
        
        let dropPinCoordinateRegion = MKCoordinateRegionMakeWithDistance(touchCoordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(dropPinCoordinateRegion, animated: true)
    }
}

extension MapVC: CLLocationManagerDelegate {
    //is our app authorize to use the location? If not, its going to request those services.
    func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()  //location is used always (open or not)
        } else {
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }
}
