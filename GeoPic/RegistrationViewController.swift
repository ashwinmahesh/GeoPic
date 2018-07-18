//
//  RegistrationViewController.swift
//  GeoPic
//
//  Created by El Capitan on 7/17/18.
//  Copyright © 2018 AshwinMahesh. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ConfirmTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func RegisterButtonPressed(_ sender: UIButton) {
        let firstName = FirstNameTextField.text!
        let lastName = LastNameTextField.text!
        let username = UsernameTextField.text!
        let password = PasswordTextField.text!
        let confPW = ConfirmTextField.text!
        var showAlert: Bool = false
        var message: String = "Please check this fields :\n"
        
        if firstName == "" {
            showAlert = true
            message = message + "First Name is empty\n"
        }
        if lastName == "" {
            showAlert = true
            message = message + "Last Name is empty\n"
        }
        if username == "" {
            showAlert = true
            message = message + "Username is empty\n"
        }
        if password == "" {
            showAlert = true
            message = message + "password is empty\n"
        }
        if password != confPW {
            showAlert = true
            message = message + "Password did not match \n"
        }
        if !showAlert {
            
            let bodyData = "first_name=\(firstName)&last_name=\(lastName)&username=\(username)&password=\(password)"
            
            Register(bodyData: bodyData) {
                data, response, error in
                do{
                    if let jsonResult = try JSONSerialization.jsonObject(with:data!, options: .mutableContainers) as? NSDictionary{
                        if  let result = jsonResult["response"] as? String {
                            if result  == "User successfully created" {
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "RegisteredSegue", sender: self)
                                }
                            }
                            else {
                                DispatchQueue.main.async {
                                    self.Alert(title: "Registration Failed", message: "Please contact administrator.")
                                }
                            }
                        }
                    }
                } catch {
                    print("\(error)")
                }
            }
        }
        
        if showAlert {
            Alert(title: "User Registration Error", message: message)
        }
        
    }
    
    func Register(bodyData: String, completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        if let urlReq = URL(string: "http://192.168.1.228:8000/processRegister/") {
            var request = URLRequest(url: urlReq)
            request.httpMethod = "POST"
            request.httpBody = bodyData.data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest, completionHandler: completionHandler)
            task.resume()
        }
    }
}

