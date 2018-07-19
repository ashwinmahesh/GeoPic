//
//  ExploreVC.swift
//  GeoPic
//
//  Created by Ashwin Mahesh on 7/17/18.
//  Copyright © 2018 AshwinMahesh. All rights reserved.
//

import UIKit

class ExploreVC: UIViewController {
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
    func fetchAll(){
        tableData=[]
        let url=URL(string: "http://192.168.1.228:8000/fetchAll/")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { (data, response, error) in
            do{
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary{
                    print(jsonResult)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        tableView.rowHeight=500
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
        cell.pictureView.image = UIImage(named: "location")
        return cell
    }
}
