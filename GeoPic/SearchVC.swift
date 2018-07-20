//
//  SearchVW.swift
//  GeoPic
//
//  Created by Ashwin Mahesh on 7/17/18.
//  Copyright © 2018 AshwinMahesh. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    var SERVER_IP:String = "http://192.168.1.20:8000"
    
    var tableData:[NSDictionary]=[]
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    @IBAction func homePushed(_ sender: UIButton) {
        performSegue(withIdentifier: "SearchToExploreSegue", sender: "SearchToExplore")
    }
    @IBAction func goPushed(_ sender: UIButton) {
        if textField.text!.count>0{
            searchRecent(searchKey: textField.text!)
        }
        else{
            fetchRecent()
        }
    }
    
    @IBAction func mapPushed(_ sender: UIButton) {
        performSegue(withIdentifier: "SearchToMapSegue", sender: "SearchToMap")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchToMapSegue"{
            let dest = segue.destination as! MapVC
            dest.fetchAll()
        }
        if segue.identifier == "SearchToSingleSegue"{
            let dest = segue.destination as! SinglePostVC
            dest.postId = sender as! Int
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
        fetchRecent()
        // Do any additional setup after loading the view.
    }
    
    func searchRecent(searchKey:String){
        tableData = []
//        let urlString = "http://192.168.1.228:8000/searchPosts/" + searchKey + "/"
        let url = URL(string: "\(SERVER_IP)/searchPosts/")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let bodyData = "searchFor=\(searchKey)"
        request.httpBody = bodyData.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with:request as URLRequest, completionHandler:{
            data, response, error in
            do{
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary{
                    print(jsonResult)
                    
                    DispatchQueue.main.async{
                        self.collectionView.reloadData()
                    }
                }
            }
            catch{
                print(error)
            }
        })
        task.resume()
    }
    
    func fetchRecent(){
        tableData=[]
//        let url = URL(string: "http://192.168.1.228:8000/getRecentPosts/")
        let url = URL(string: "\(SERVER_IP)/getRecentPosts/")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler:{
            data, response, error in
            do{
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary{
                    let posts = jsonResult["posts"] as! NSMutableArray
                    for post in posts{
                        let postFixed = post as! NSDictionary
                        self.tableData.append(postFixed)
                    }
                    DispatchQueue.main.async{
                        self.collectionView.reloadData()
                    }
                }
            }
            catch{
                print(error)
            }
        })
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension SearchVC:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCell
        cell.post_id = tableData[indexPath.row]["id"] as! Int
        cell.imageView.image = UIImage(named: "sample picture")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected a cell!")
        let cell = collectionView.cellForItem(at: indexPath) as! SearchCell
        performSegue(withIdentifier: "SearchToSingleSegue", sender: cell.post_id!)
    }
}
