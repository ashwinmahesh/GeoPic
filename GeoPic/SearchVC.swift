//
//  SearchVW.swift
//  GeoPic
//
//  Created by Ashwin Mahesh on 7/17/18.
//  Copyright © 2018 AshwinMahesh. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    var tableData:[String]=[]
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    @IBAction func homePushed(_ sender: UIButton) {
        performSegue(withIdentifier: "SearchToExploreSegue", sender: "SearchToExplore")
    }
    @IBAction func textEntered(_ sender: UITextField) {
        
    }
    @IBAction func mapPushed(_ sender: UIButton) {
        performSegue(withIdentifier: "SearchToMapSegue", sender: "SearchToMap")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchRecent()
        // Do any additional setup after loading the view.
    }
    
    func searchRecent(searchKey:String){
        tableData = []
        let urlString = "http://192.168.1.228:8000/searchPosts/" + searchKey + "/"
        let url = URL(string: urlString)
        let session = URLSession.shared
        let task = session.dataTask(with:url!, completionHandler:{
            data, response, error in
            do{
                
            }
            catch{
                
            }
        })
        task.resume()
    }
    
    func fetchRecent(){
        tableData=[]
        let url = URL(string: "http://192.168.1.228:8000/getRecentPosts/")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler:{
            data, response, error in
            do{
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary{
                    let posts = jsonResult["posts"] as! NSMutableArray
                    for post in posts{
                        let postFixed = post as! NSDictionary
                        print("Poster: ",postFixed["poster"] as! String, "Location: ", postFixed["location"])
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
        
        return cell
    }
}
