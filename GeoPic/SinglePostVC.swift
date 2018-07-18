//
//  SinglePostVC.swift
//  GeoPic
//
//  Created by Ashwin Mahesh on 7/18/18.
//  Copyright © 2018 AshwinMahesh. All rights reserved.
//

import UIKit

class SinglePostVC: UIViewController {

    var postId:Int?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionView: UITextView!
    
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
        let url = URL(string: "http://192.168.1.228:8000/getPost/")
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
                    }
                }
            }
            catch{
                
            }
        }
        task.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
