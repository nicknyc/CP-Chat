//
//  MoreViewController.swift
//  CP Chat
//
//  Created by Pakkapol Rattanapongsen on 5/2/2560 BE.
//  Copyright © 2560 Pakkapol Rattanapongsen. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
    
    var userId:String?
    var sessionId:String?
    
    @IBOutlet weak var sessionIdField: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBAction func signOutButtonClicked(_ sender: Any) {
        signOutHandle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.userId = UserDefaults.standard.string(forKey: "username")
        
        usernameLabel.text = "Username: \(self.userId!)"
        
        self.sessionId = UserDefaults.standard.string(forKey: "sessionId")
        sessionIdField.text = "Session ID: \(sessionId!)"
    }

    func signOutHandle() {
        UserDefaults.standard.set("", forKey: "sessionId")
        UserDefaults.standard.set(false, forKey: "isUserSignIn")
        UserDefaults.standard.synchronize();
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "signIn")
        self.present(viewController, animated: true, completion: nil)

    }
}
