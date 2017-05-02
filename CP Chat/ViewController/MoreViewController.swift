//
//  MoreViewController.swift
//  CP Chat
//
//  Created by Pakkapol Rattanapongsen on 5/2/2560 BE.
//  Copyright © 2560 Pakkapol Rattanapongsen. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
    
    var sessionId:String?
    
    @IBOutlet weak var sessionIdLabel: UILabel!
    
    @IBAction func signOutButtonClicked(_ sender: Any) {
        signOutHandle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.sessionId = UserDefaults.standard.string(forKey: "sessionId")
        sessionIdLabel.text = "Session ID: \(self.sessionId!)"
        
        self.title = UserDefaults.standard.string(forKey: "username")
    }

    func signOutHandle() {
        UserDefaults.standard.set(sessionId, forKey: "")
        UserDefaults.standard.set(false, forKey: "isUserSignIn")
        UserDefaults.standard.synchronize();
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "signIn")
        self.present(viewController, animated: true, completion: nil)

    }
}
