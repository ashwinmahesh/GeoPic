//
//  ExploreVC.swift
//  GeoPic
//
//  Created by Ashwin Mahesh on 7/17/18.
//  Copyright © 2018 AshwinMahesh. All rights reserved.
//

import UIKit

class ExploreVC: UIViewController {
    var tableData:[NSDictionary]=[["name":"Michael Choi", "description":"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
                                   "address":"1920 Zanker Rd, San Jose, CA 95112"
        ]]
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableData.append(newDict)
        tableView.delegate=self
        tableView.dataSource=self
        tableView.rowHeight=500
//        let newDict:NSDictionary =
        // Do any additional setup after loading the view.
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
        print(currentPost["description"] as! String)
        cell.nameLabel.text=currentPost["name"] as! String
        cell.addressLabel.text=currentPost["address"] as! String
        cell.descriptionView.text=currentPost["description"] as! String
        cell.pictureView.image = UIImage(named: "location")
        return cell
    }
}
