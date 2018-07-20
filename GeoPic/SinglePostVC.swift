//
//  SinglePostVC.swift
//  GeoPic
//
//  Created by Ashwin Mahesh on 7/18/18.
//  Copyright © 2018 AshwinMahesh. All rights reserved.
//

import UIKit

class SinglePostVC: UIViewController {
//    var SERVER_IP:String = "http://192.168.1.20:8000"
    var SERVER_IP:String = Server.IP

    var postId:Int?
    
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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
//                    let imageData = jsonResult["image_data"] as! String
//                    if let decodedData = Data(base64Encoded: imageData, options: .ignoreUnknownCharacters){
//                        let decodedImage:UIImage = UIImage(data: decodedData)!
                        DispatchQueue.main.async {
                            self.nameLabel.text = (jsonResult["first_name"] as! String) + " " + (jsonResult["last_name"] as! String)
                            self.addressLabel.text = (jsonResult["location"] as! String)
                            self.descriptionView.text = (jsonResult["description"] as! String)
                            self.imageView.image = UIImage(named: "sample picture")
                            self.dateLabel.text = jsonResult["created_at"] as! String
                        }
//                    }
                }
            }
            catch{
                
            }
        }
        task.resume()
    }
    

}
