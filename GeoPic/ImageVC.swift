//
//  ImageVC.swift
//  CoreLocationPractice
//
//  Created by Drew on 7/17/18.
//  Copyright © 2018 Drew. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class ImageVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var SERVER_IP:String = "http://192.168.1.20:8000"
    
    @IBAction func backPushed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let manager = CLLocationManager()
    var myLongitude = ""
    var myLatitude = ""
    var image_data: String = ""
    var image_chosen=false
    
    @IBOutlet var buttons: [UIButton]!
    //    Test function to test pulling from server
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    
//    Button Action, sends to server
    @IBAction func postPressed(_ sender: UIButton) {
        print("You are pressing post")
        if image_chosen==false{
            return
        }
        if locationLabel.text==""{
            return
        }
        let image = UIImagePNGRepresentation(imageView.image!)!
        let imageData = image.base64EncodedString(options: .lineLength64Characters)
//        print(imageData)
//        let url = URL(string: "http://192.168.1.228:8000/uploadImage/")
        let url = URL(string: "\(SERVER_IP)/uploadImage/")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        var username:String=""
        
        //Get user info
        let coreRequest:NSFetchRequest<User>=User.fetchRequest()
        do{
            let result = try context.fetch(coreRequest).first
            if let user = result{
                username = user.username!
            }
        }
        catch{
            print(error)
        }
        //End of get user info
        
        let imageData_temp = "Here is temporary image data!"
        let bodyData = "username=\(username)&image_data=\(imageData_temp)&description=\(descriptionTextView.text!)&location=\(locationLabel.text!)&lat=\(myLatitude)&long=\(myLongitude)"
        request.httpBody = bodyData.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest){
            data, response, error in
            do{
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary{
                    print(jsonResult)
                }
            }
            catch{
                print(error)
            }
        }
        task.resume()
        performSegue(withIdentifier: "UploadToExploreSegue", sender: "UploadToExplore")
    }
//    Choose from photo library
    @IBAction func importPressed(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true) {
        }
        image_chosen=true
    }
    
//    Camera picture
    @IBAction func takePicturePressed(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .camera
        image.allowsEditing = false
        self.present(image, animated: true) {
        }
        image_chosen=true
    }
//    Set picture
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        } else {
            print("error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        for button in buttons{
            button.layer.cornerRadius=6
        }
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
    }
}

//Map
extension ImageVC: CLLocationManagerDelegate, UISearchBarDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        myLatitude = String(location.coordinate.latitude)
        myLongitude = String(location.coordinate.longitude)
//        print(myLongitude)
//        print(myLatitude)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
//        print(myLocation)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil {
//                print("error")
            } else {
                if let place = placemark?[0] {
                    if let checker = place.subThoroughfare{
                        self.locationLabel.text = "\(place.subThoroughfare!) \(place.thoroughfare!), \(place.locality!), \(place.administrativeArea!) \(place.postalCode!)"
                    }
                }
            }
        }
    }
}

