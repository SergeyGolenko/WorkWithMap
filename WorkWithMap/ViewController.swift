//
//  ViewController.swift
//  WorkWithMap
//
//  Created by Сергей Голенко on 29.01.2021.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView : MKMapView!
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        //задаю точность определения местоположения
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }


}

