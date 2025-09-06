//
//  MapViewController.swift
//  BaseProjectSwift
//
//  Created by Bé Gạo on 7/4/24.
//

import Foundation
import UIKit
import MapKit
import RxSwift
import RxCocoa
import RxGesture
import CoreLocation

class MapViewController: BaseViewController, BindableType {
    var viewModel: MapViewModel!
    let disposeBag = DisposeBag()
    var locationManager:CLLocationManager!

    let mapView : MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    let myLocationImage = UIImageView().style {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.sizeItem(40)
        $0.image = UIImage(named: "mylocation")?.withTintColor(.white)
    }
    
    let regionRadius: Double = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initUI() {
        super.initUI()
        self.view.backgroundColor = .blue
        self.view.addSubview(mapView)
        self.view.addSubview(myLocationImage)
        
        mapView.constraintsTo(view: self.view)
        myLocationImage.constraintsTo(view: mapView, positions: .right, constant: -12)
        myLocationImage.constraintsTo(view: mapView, positions: .bottom, constant: -12)
        requestUserLocation()
    }
    
    override func binding() {
        myLocationImage.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                print("tap")
                self?.centerMapOnUserLocation()
            }).disposed(by: disposeBag)
    }
    
    private func requestUserLocation() {
        locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()

        let myQueue = DispatchQueue(label:"myOwnQueue", qos: .utility)
        myQueue.async { [weak self] in
          if CLLocationManager.locationServicesEnabled() {
            // your code here
              self?.locationManager.startUpdatingLocation()
          }
        }
    }
    
    func centerMapOnUserLocation() {
            guard let coordinate = locationManager.location?.coordinate else {return}
            let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation

        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)
            }
        }

    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}
