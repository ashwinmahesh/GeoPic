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
    
    var tableData:[NSDictionary]=[]

    @IBOutlet weak var addressLabel: UILabel!
    
    @IBAction func homePushed(_ sender: UIButton) {
        performSegue(withIdentifier: "MapToExploreSegue", sender: "MapToExplore")
    }
    
    @IBAction func searchPushed(_ sender: UIButton) {
        performSegue(withIdentifier: "MapToSearchSegue", sender: "MapToSearch")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let postID = sender as? Int{
            let dest = segue.destination as! SinglePostVC
            dest.postId = postID
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
        addressLabel.text=""
        manager.delegate = self
        mapView.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
//        fetchAll()
//        print(tableData[1])
//        let long = tableData[1]["longitude"] as! String
//        print(long)
//        if let longDouble = Double(long)
//        {
//            print("I can convert to double")
//        }
        placePhotos()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
//        fetchAll()
//        placePhotos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func placePhotos(){
//        let annotation=MKPointAnnotation()
        for post in tableData{
            let annotation = customAnnotation()
            let long = Double(post["longitude"] as! String)!
            let lat = Double(post["latitude"] as! String)!
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(long, lat)
            annotation.coordinate = location
            annotation.title = (post["first_name"] as! String) + " " + (post["last_name"] as! String)
            annotation.subtitle = post["created_at"] as! String
            annotation.postID = post["id"] as! Int
            mapView.addAnnotation(annotation)
        }
    }
    
    func fetchAll(){
        tableData=[]
        let url=URL(string: "http://192.168.1.228:8000/fetchAll/")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { (data, response, error) in
            do{
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary{
//                    print(jsonResult)
                    let posts = jsonResult["posts"] as! NSMutableArray
                    for post in posts{
                        let postFixed = post as! NSDictionary
                        self.tableData.append(postFixed)
                    }
                    DispatchQueue.main.async{
                        self.placePhotos()
                    }
                }
            }
            catch{
                print(error)
            }
        }
        task.resume()
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
        if let annotation = view.annotation as? customAnnotation{
            print("You selected a point: \(annotation.title!), wih id: \(annotation.postID!)")
            performSegue(withIdentifier: "MapToSingleSegue", sender: annotation.postID!)
        }
    }
}

class customAnnotation:MKPointAnnotation{
    var postID:Int?
}
