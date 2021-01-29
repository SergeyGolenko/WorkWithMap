//
//  ViewController.swift
//  WorkWithMap
//
//  Created by Сергей Голенко on 29.01.2021.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate{
    
    @IBOutlet weak var mapView : MKMapView!
    private let locationManager = CLLocationManager()
    private var userLocation = CLLocation()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        //задаю точность определения местоположения
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = kCLDistanceFilterNone
        //запрос разрешения на получение данных о местоположении юзера
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last
        userLocation = lastLocation!
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let coordinate2D = userLocation.coordinate
        //coordinateSpan увеличивает местоположение
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        var region = MKCoordinateRegion(center: coordinate2D, span: coordinateSpan)
        mapView.setRegion(region, animated: true)
    }

}

