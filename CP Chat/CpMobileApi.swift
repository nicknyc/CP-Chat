//
//  CpMobileApi.swift
//  CP Chat
//
//  Created by Pakkapol Rattanapongsen on 5/2/2560 BE.
//  Copyright © 2560 Pakkapol Rattanapongsen. All rights reserved.
//

import Foundation
import UIKit

class CpMobileApi {
    static let signInURL = URL(string: "https://mis.cp.eng.chula.ac.th/mobile/service.php?q=api/signIn")
    static let getContactListUrl = URL(string: "https://mis.cp.eng.chula.ac.th/mobile/service.php?q=api/getContact")
    static let searchUserUrl = URL(string: "https://mis.cp.eng.chula.ac.th/mobile/service.php?q=api/searchUser")
    static let addContactUrl = URL(string: "https://mis.cp.eng.chula.ac.th/mobile/service.php?q=api/addContact")
    static let getMessageUrl = URL(string: "https://mis.cp.eng.chula.ac.th/mobile/service.php?q=api/getMessage")
    
    
    //let session = URLSession.shared

    /*func makeRequest(url:URL, params:String) -> AnyObject{
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = params.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            if error != nil {
                return
            }
            else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!) as? [String: AnyObject]
                    {
                        DispatchQueue.main.async {
                            if(json["type"] as! String == "error"){
                                self.errorHandle(error: json["content"]! as! String)
                                return nil
                            }else{
                                return json
                            }
                        }
                    }
                }
                catch { }
            }
        })
        task.resume()
    }
    
    func errorHandle(error:String){
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(doneAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func getContactList() -> [String]{
        let sessionId = UserDefaults.standard.string(forKey: "sessionId")
        let url     = getContactListUrl!
        let params = "sessionid=\(sessionId)"
        
        let json = makeRequest(url: url, params: params)
        if json != nil{
            return (json as! [String: AnyObject])["content"] as! [String]
        }
    }*/
    
}
