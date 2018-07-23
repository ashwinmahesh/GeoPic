//
//  ExploreVC.swift
//  GeoPic
//
//  Created by Ashwin Mahesh on 7/17/18.
//  Copyright © 2018 AshwinMahesh. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class ExploreVC: UIViewController {
//    var SERVER_IP:String = "http://192.168.1.20:8000"
    var SERVER_IP:String = Server.IP
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tableData:[NSDictionary]=[]
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func mapPushed(_ sender: UIButton) {
        performSegue(withIdentifier: "ExploreToMapSegue", sender: "ExploreToMap")
    }
    
    @IBAction func searchPushed(_ sender: UIButton) {
        performSegue(withIdentifier: "ExploreToSearchSegue", sender: "Explore")
    }
    
    @IBAction func uploadPushed(_ sender: UIButton) {
        performSegue(withIdentifier: "ExploreToUploadSegue", sender: "ExploreToUpload")
    }
    
    @IBAction func logoutPushed(_ sender: UIBarButtonItem) {
        let request:NSFetchRequest<User>=User.fetchRequest()
        do{
            let result = try context.fetch(request).first
            if let user = result{
                user.logged=false
                user.first_name=""
                user.last_name=""
                user.username=""
                appDelegate.saveContext()
            }
        }
        catch{
            print(error)
        }
        performSegue(withIdentifier: "ExploreToMainSegue", sender: "ExploreToMain")
    }
    
    func fetchAll(){
        tableData=[]
//        let url=URL(string: "http://192.168.1.228:8000/fetchAll/")
        let url=URL(string: "\(SERVER_IP)/fetchAll/")
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
                        self.tableView.reloadData()
                    }
                }
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ExploreToMapSegue"{
            let dest = segue.destination as! MapVC
            dest.fetchAll()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        tableView.rowHeight=460
//        fetchAll()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ExploreVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PictureCell", for: indexPath) as! PictureCell
        let currentPost = tableData[indexPath.row]
        cell.nameLabel.text=(currentPost["first_name"] as! String) + " " + (currentPost["last_name"] as! String)
        cell.addressLabel.text=currentPost["location"] as! String
        cell.descriptionView.text=currentPost["description"] as! String
        
        //Adding in image stuff here
        let imagePath = currentPost["imagePath"]!
        Alamofire.request("\(SERVER_IP)/static/login_registration/images/\(imagePath)").responseData { (response) in
            if let data = response.data{
                let image = UIImage(data: data)
                cell.pictureView.image = image
            }
        }
        
        //END OF IMAGE STUFF
//        let year = (currentPost["created_at"] as! String)[0...3]
//        let month = (currentPost["created_at"] as! String)[5...6]
        
        //Making date modifications here
        let created_at = currentPost["created_at"] as! String
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
        
//        cell.dateLabel.text=currentPost["created_at"] as! String
        cell.dateLabel.text = "\(month)/\(day)/\(year) at \(hour):\(minute) \(AmPm)"
        return cell
    }
}
