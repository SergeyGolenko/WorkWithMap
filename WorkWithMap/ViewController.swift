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
        let alertVC = UIAlertController(title: "Add Address", message:nil, preferredStyle: .alert)
        alertVC.addTextField { (textField) in
            
        }
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            if let textField = alertVC.textFields?.first {
                // address
                self.reverseGeocode(address: textField.text!) { (placemark) in
                    
                    let destinationPlacemark = MKPlacemark(coordinate: placemark.location!.coordinate)
                     let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
                    MKMapItem.openMaps(with: [destinationMapItem], launchOptions: nil)
                }
            
                
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
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
        addPointOfInterest()
        
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
    
    private func addPointOfInterest(){
        let annotation = MKPointAnnotation()
       // annotation.imageURL = "pointCoffee"
        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.334395, longitude: -122.040012)
        self.mapView.addAnnotation(annotation)
       self.mapView.addOverlay(MKCircle(center: annotation.coordinate, radius: 500))
        let region = CLCircularRegion(center: annotation.coordinate, radius: 500, identifier: "coffee")
        region.notifyOnEntry = true
        region.notifyOnExit = true
        self.locationManager.startMonitoring(for: region)
    }
    
    private func reverseGeocode(address:String,completion: @escaping(CLPlacemark) -> ()){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            guard let placemarks = placemarks,
                  let placemark = placemarks.first else {return}
           completion(placemark)
        }
        
    }
    
    private func addPlacemarkToMap(placemark:CLPlacemark){
        let coordinate = placemark.location?.coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate!
        self.mapView.addAnnotation(annotation)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Я ТУТА")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            var circleRenderer = MKCircleRenderer(circle: overlay as! MKCircle)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = .red
            circleRenderer.fillColor = .purple
            circleRenderer.alpha = 0.4
            return circleRenderer
        }
        return MKOverlayRenderer()
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






//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKUserLocation{
//            var userView = mapView.dequeueReusableAnnotationView(withIdentifier: "car")
//            if userView == nil {
//                userView = MKAnnotationView(annotation: annotation, reuseIdentifier: "car")
//                userView?.canShowCallout = true
//            } else {
//                userView?.annotation = annotation
//            }
//            userView?.image = UIImage(named: "car")
//            return userView
//        }
//
//        if annotation is MKUserLocation {
//            return nil
//        }
//
//        var coffeeAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CoffeeAnnotationView")
//        if coffeeAnnotationView == nil {
//            coffeeAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CoffeeAnnotationView")
//            coffeeAnnotationView?.canShowCallout = true
//        } else {
//            coffeeAnnotationView?.annotation = annotation
//        }
//        if let coffeeAnnotation = annotation as? CoffeeAnnotation {
//            coffeeAnnotationView?.image = UIImage(named: coffeeAnnotation.imageURL)
//            return coffeeAnnotationView
//        }
//        //configureView(coffeeAnnotationView)
//        return MKAnnotationView()
//    }

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
