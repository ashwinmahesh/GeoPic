//
//  ViewController.swift
//  GeoPic
//
//  Created by Ashwin Mahesh on 7/17/18.
//  Copyright © 2018 AshwinMahesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
//    var SERVER_IP:String = "http://192.168.1.20:8000"
    var SERVER_IP:String = Server.IP
    @IBOutlet weak var UsernameLabel: UITextField!
    @IBOutlet weak var PasswordLabel: UITextField!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let thisUser = UserLog()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        DispatchQueue.main.async {
            if self.thisUser.isLogged() {
                self.performSegue(withIdentifier: "LoggedSegue", sender: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        
        let username = UsernameLabel.text!
        let password = PasswordLabel.text!
        
        login(username: username, password: password) {
            data, response, error in
            
            do{
                if let jsonResult = try JSONSerialization.jsonObject(with:data!, options: .mutableContainers) as? NSDictionary{
                    if let result = jsonResult["response"] as? String {
                        if result == "Successful Login" {
                            print(jsonResult)
                            
                            let firstname = jsonResult["first_name"] as! String
                            let lastname = jsonResult["last_name"] as! String
                            let username = jsonResult["username"] as! String
                            
                            self.thisUser.Log(username: username, firstname: firstname, lastname: lastname)
                            
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "LoggedSegue", sender: nil)
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                self.Alert(title: "Login Failed", message: "User and Password didn't match")
                            }
                        }
                    }
                }
            } catch {
                print("\(error)")
            }
        }
    }
    
    func login(username: String, password: String, completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
//        if let urlReq = URL(string: "http://192.168.1.228:8000/processLogin/") {
        if let urlReq = URL(string: "\(SERVER_IP)/processLogin/") {
        
            var request = URLRequest(url: urlReq)
            request.httpMethod = "POST"
            let bodyData = "username=\(username)&password=\(password)"
            request.httpBody = bodyData.data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
            task.resume()
        }
    }
}

extension UIViewController
{
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer (
            target: self,
            action: #selector(UIViewController.dismissKeyboard)
        )
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func Alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
}
