//
//  ContactTableViewController.swift
//  CP Chat
//
//  Created by Pakkapol Rattanapongsen on 5/2/2560 BE.
//  Copyright © 2560 Pakkapol Rattanapongsen. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController {
    
    var contacts:[String] = []
    let sessionId = UserDefaults.standard.string(forKey: "sessionId")!
    let sectionHeader = ["Mobile Application Class"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getContactList()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }
    
    func getContactList() {
        let session = URLSession.shared
        
        var request = URLRequest(url: CpMobileApi.getContactListUrl!)
        request.httpMethod = "POST"
        
        let params = "sessionid=\(self.sessionId)"
        request.httpBody = params.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            if error != nil {
                self.errorHandle(error: "Check your network connection and try again.")
            }
            else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!) as? [String: AnyObject]
                    {
                        DispatchQueue.main.async {
                            if(json["type"] as! String == "error"){
                                self.errorHandle(error: json["content"] as! String)
                            }else if(json["type"] as! String == "contact"){
                                self.contacts = json["content"] as! [String]
                                self.tableView.reloadData()
                                return
                            }
                        }
                    }
                }
                catch { }
            }
        })
        task.resume()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = contacts[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionHeader[section]
    }
    
    func errorHandle(error:String){
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(doneAction)
        self.present(alert, animated: true, completion: nil)
    }
}
