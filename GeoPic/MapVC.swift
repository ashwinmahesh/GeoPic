//
//  MapVC.swift
//  GeoPic
//
//  Created by Ashwin Mahesh on 7/17/18.
//  Copyright © 2018 AshwinMahesh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {

    @IBOutlet weak var addressLabel: UILabel!
    
    @IBAction func homePushed(_ sender: UIButton) {
        performSegue(withIdentifier: "MapToExploreSegue", sender: "MapToExplore")
    }
    
    @IBAction func searchPushed(_ sender: UIButton) {
        performSegue(withIdentifier: "MapToSearchSegue", sender: "MapToSearch")
    }
    
    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressLabel.text=""
        manager.delegate = self
        mapView.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        placePhotos()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func placePhotos(){
//        let annotation=MKPointAnnotation()
        let annotation = customAnnotation()
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.37535889999999, -121.91019770000003)
        annotation.coordinate = location
        annotation.title = "Michael Choi"
        annotation.subtitle = "Posted on 7/16/18"
        annotation.postID = 1
        mapView.addAnnotation(annotation)
    }
}
extension MapVC:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.005, 0.005)
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        mapView.setRegion(region, animated: true)
        
        self.mapView.showsUserLocation = true
        
        CLGeocoder().reverseGeocodeLocation(location){
            placemark, error in
            if error != nil{
                self.addressLabel.text=""
//                print(error)
            }
            else{
                if let place = placemark?[0]{
                    if let check = place.subThoroughfare{
                        self.addressLabel.text = "\(place.subThoroughfare!) \(place.thoroughfare!), \(place.locality!), \(place.administrativeArea!) \(place.postalCode!)"
                    }
                }
            }
        }
    }
}
extension MapVC:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation as! customAnnotation
        print("You selected a point: \(annotation.title!), wih id: \(annotation.postID!)")
        //Perform segue to page with this picture
        //Make custom class for annotation
    }
}

class customAnnotation:MKPointAnnotation{
    var postID:Int?
}
