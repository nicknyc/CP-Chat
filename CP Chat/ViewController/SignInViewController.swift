//
//  SignInViewController.swift
//  CP Chat
//
//  Created by Pakkapol Rattanapongsen on 5/2/2560 BE.
//  Copyright © 2560 Pakkapol Rattanapongsen. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    let signInUrl = URL(string: "https://mis.cp.eng.chula.ac.th/mobile/service.php?q=api/signIn")
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBAction func signInClicked(_ sender: Any) {
        signInHandle()
    }
    
    func signInHandle(){
        let username = usernameField.text!
        let password = passwordField.text!
        if(username != "" && password != ""){
            let session = URLSession.shared
            
            var request = URLRequest(url: self.signInUrl!)
            request.httpMethod = "POST"
            
            let params = "username=\(username)&password=\(password)"
            request.httpBody = params.data(using: String.Encoding.utf8)
            
            self.usernameField.isEnabled = false
            self.passwordField.isEnabled = false
            self.signInButton.isEnabled = false
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
                if error != nil {
                    self.errorHandle(error: "Check your network connection and try again.")
                }
                else {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!) as? [String: String]
                        {
                            DispatchQueue.main.async {
                                if(json["type"] == "error"){
                                    self.errorHandle(error: json["content"]!)
                                }else if(json["type"] == "sessionid"){
                                    self.signInSuccess(sessionId: json["content"]!, username: username)
                                    return
                                }
                            }
                        }
                    }
                    catch { }
                }
            })
            task.resume()
            self.usernameField.isEnabled = true
            self.passwordField.isEnabled = true
            self.signInButton.isEnabled = true
        }else{
            self.errorHandle(error: "Fields cannot be empty!")
        }
    }
    
    func signInSuccess(sessionId:String, username:String){
        UserDefaults.standard.set(sessionId, forKey: "sessionId")
        UserDefaults.standard.set(true, forKey: "isUserSignIn")
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.synchronize();
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "mainMenu")
        self.present(viewController, animated: true, completion: nil)
    }
    
    func errorHandle(error:String){
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(doneAction)
        self.present(alert, animated: true, completion: nil)
    }
}
