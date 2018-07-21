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
import Alamofire

class ImageVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
//    var SERVER_IP:String = "http://192.168.1.20:8000"
    var SERVER_IP:String = Server.IP
    
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
        
        var username:String=""
        var count:Int16=0
        //Get user info
        let coreRequest:NSFetchRequest<User>=User.fetchRequest()
        do{
            let result = try context.fetch(coreRequest).first
            if let user = result{
                username = user.username!
                count = user.upload_count
                user.upload_count+=1
                appDelegate.saveContext()
            }
        }
        catch{
            print(error)
        }
        //End of get user info
        
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.2)!
        
        let parameters = ["username":username, "lat":myLatitude, "long":myLongitude, "location":locationLabel.text!, "description":descriptionTextView.text!, "image_name":"\(username)_\(count)"]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData, withName: "image", fileName:"\(username)_\(count)", mimeType:"image/jpg")
            for (key, value) in parameters{
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: "\(SERVER_IP)/alamoDataUpload/") { (result) in
            switch result{
            case .success (let upload, _, _):
                upload.responseJSON{
                    response in
                    print(response.result.value)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
//
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

