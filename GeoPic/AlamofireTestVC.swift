//
//  AlamofireTestVC.swift
//  GeoPic
//
//  Created by Ashwin Mahesh on 7/20/18.
//  Copyright © 2018 AshwinMahesh. All rights reserved.
//

import UIKit
import Alamofire

class AlamofireTestVC: UIViewController {
    var SERVER_IP:String = Server.IP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadImage()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeGetRequest(){
        Alamofire.request("\(SERVER_IP)/alamoTest/").responseJSON { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Result: \(response.result)")
            
            if let json = response.result.value {
                print("JSON: \(json)")
            }
        }
    }
    
    func uploadImage(){
        let image = UIImage(named: "sample picture")!
        
        let imageData = UIImageJPEGRepresentation(image, 0.2)!
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData, withName:"imageset", fileName:"image.jpg", mimeType:"image/jpg")
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
        
        
    }
 

}
