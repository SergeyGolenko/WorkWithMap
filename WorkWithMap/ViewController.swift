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
    
    
    @IBOutlet weak var pageControllMap: UISegmentedControl!
    @IBOutlet weak var mapView : MKMapView!
    private let locationManager = CLLocationManager()
    
    private var userCoordinateForNewAnnotation = CLLocationCoordinate2D()
    
    
    @IBAction func addAnnotationButton(_ sender: UIButton) {
        
        let newCoordinate = userCoordinateForNewAnnotation
        let myAnnotation = CoffeeAnnotation()
        myAnnotation.imageURL = "pointCoffee"
        myAnnotation.coordinate = userCoordinateForNewAnnotation
        self.mapView.addAnnotation(myAnnotation)
    }
    

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
        self.pageControllMap.addTarget(self, action: #selector(mapTypeChanged), for: .valueChanged)
    }
    
    @objc func mapTypeChanged(segmentControl:UISegmentedControl){
        switch segmentControl.selectedSegmentIndex{
        case 0 : mapView.mapType = .standard
        case 1 : mapView.mapType = .satellite
        case 2 : mapView.mapType = .hybrid
        default:
            break
        }
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last
       
    }
    
    
    //Привязывает вид карты к положению userLocation 
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let coordinate2D = userLocation.coordinate
        userCoordinateForNewAnnotation = coordinate2D
        //coordinateSpan увеличивает местоположение
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        var region = MKCoordinateRegion(center: coordinate2D, span: coordinateSpan)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            var userView = mapView.dequeueReusableAnnotationView(withIdentifier: "car")
            if userView == nil {
                userView = MKAnnotationView(annotation: annotation, reuseIdentifier: "car")
                userView?.canShowCallout = true
            } else {
                userView?.annotation = annotation
            }
            userView?.image = UIImage(named: "car")
            return userView
        }
        
        var coffeeAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CoffeeAnnotationView")
        if coffeeAnnotationView == nil {
            coffeeAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CoffeeAnnotationView")
            coffeeAnnotationView?.canShowCallout = true
        } else {
            coffeeAnnotationView?.annotation = annotation
        }
        if let coffeeAnnotation = annotation as? CoffeeAnnotation {
            coffeeAnnotationView?.image = UIImage(named: coffeeAnnotation.imageURL)
        }
        //configureView(coffeeAnnotationView)
        return coffeeAnnotationView
    }
    
//    private func configureView(_ annotationView :MKAnnotationView?) {
//
//        let view = UIView(frame: CGRect.zero)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        view.backgroundColor = UIColor.red
//
//        annotationView?.leftCalloutAccessoryView = UIImageView(image: UIImage(named :"car"))
//        annotationView?.rightCalloutAccessoryView = UIImageView(image: UIImage(named :"pointCoffee"))
//        annotationView?.detailCalloutAccessoryView = view
//
//    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.subviews.forEach{ subView in
            subView.removeFromSuperview()
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? CoffeeAnnotation else {return}
        let coffeeCalloutView = CoffeeCalloutView(annotation: annotation)
        coffeeCalloutView.add(to: view)
    }

}

