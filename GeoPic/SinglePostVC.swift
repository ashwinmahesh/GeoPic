//
//  SinglePostVC.swift
//  GeoPic
//
//  Created by Ashwin Mahesh on 7/18/18.
//  Copyright © 2018 AshwinMahesh. All rights reserved.
//

import UIKit
import Alamofire

class SinglePostVC: UIViewController {
//    var SERVER_IP:String = "http://192.168.1.20:8000"
    var SERVER_IP:String = Server.IP

    var postId:Int?
    var imagePath:String?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBAction func homePushed(_ sender: UIButton) {
        performSegue(withIdentifier: "SingleToExploreSegue", sender: "SingleToExplore")
    }
    
    @IBAction func searchPushed(_ sender: UIButton) {
        performSegue(withIdentifier: "SingleToSearchSegue", sender: "SingleToSearch")
    }
    
    @IBAction func backPushed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.layer.cornerRadius=6
        getPost()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getPost(){
//        let url = URL(string: "http://192.168.1.228:8000/getPost/")
        let url = URL(string: "\(SERVER_IP)/getPost/")
        var request = URLRequest(url: url!)
        request.httpMethod="POST"
        let bodyData = "post_id=\(postId!)"
        request.httpBody = bodyData.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            do{
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary{
                    print(jsonResult)
                    DispatchQueue.main.async {
                        self.nameLabel.text = (jsonResult["first_name"] as! String) + " " + (jsonResult["last_name"] as! String)
                        self.addressLabel.text = (jsonResult["location"] as! String)
                        self.descriptionView.text = (jsonResult["description"] as! String)

                        //Starting date modifications here
                        let created_at = jsonResult["created_at"] as! String
                        let yearIndex = created_at.index(created_at.startIndex, offsetBy: 0)...created_at.index(created_at.startIndex, offsetBy:3)
                        let monthIndex = created_at.index(created_at.startIndex, offsetBy:5)...created_at.index(created_at.startIndex, offsetBy:6)
                        let dayIndex = created_at.index(created_at.startIndex, offsetBy:8)...created_at.index(created_at.startIndex, offsetBy:9)
                        let hourIndex = created_at.index(created_at.startIndex, offsetBy:11)...created_at.index(created_at.startIndex, offsetBy:12)
                        let minuteIndex = created_at.index(created_at.startIndex, offsetBy:14)...created_at.index(created_at.startIndex, offsetBy:15)
                        
                        let year = created_at[yearIndex]
                        let month = created_at[monthIndex]
                        let day = created_at[dayIndex]
                        
                        let hour = String(Int(created_at[hourIndex])! % 12)
                        var AmPm = ""
                        if Int(created_at[hourIndex])! / 12 == 0{
                            AmPm = "AM"
                        }
                        else{
                            AmPm = "PM"
                        }
                        let minute = created_at[minuteIndex]
                        //End of date modification
                        
//                        self.dateLabel.text = jsonResult["created_at"] as! String
                        self.dateLabel.text = "\(month)/\(day)/\(year) at \(hour):\(minute) \(AmPm)"
                        let this_imagePath = jsonResult["image_path"] as! String
                        self.getImage(imagePath: this_imagePath)
                    }
                }
            }
            catch{
                
            }
        }
        task.resume()
    }
    
    func getImage(imagePath:String){
        Alamofire.request("\(SERVER_IP)/static/login_registration/images/\(imagePath)").responseData { (response) in
            if let data = response.data{
                print("Getting data")
                let image = UIImage(data: data)
                self.imageView.image = image
            }
        }
    }
    

}
