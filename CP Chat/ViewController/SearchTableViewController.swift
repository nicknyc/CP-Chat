//
//  SearchTableViewController.swift
//  CP Chat
//
//  Created by Pakkapol Rattanapongsen on 5/2/2560 BE.
//  Copyright © 2560 Pakkapol Rattanapongsen. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)
    let sessionId = UserDefaults.standard.string(forKey: "sessionId")!
    
    var contacts:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = contacts[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < contacts.count{
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let addFriendsAction = UIAlertAction(title: "Add this user", style: .default, handler: {_ in
                self.addFriend(username: self.contacts[indexPath.row])
            })
            
            actionSheet.addAction(addFriendsAction)
            actionSheet.addAction(cancelAction)
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func addFriend(username:String){
        let session = URLSession.shared
        
        var request = URLRequest(url: CpMobileApi.addContactUrl!)
        request.httpMethod = "POST"
        
        let params = "sessionid=\(self.sessionId)&username=\(username)"
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
                        print(json)
                        DispatchQueue.main.async {
                            if(json["type"] as! String == "error"){
                                self.errorHandle(error: json["content"] as! String)
                            }else if(json["type"] as! String == "addContact"){
                                let result = json["content"] as! Bool
                                if result == true{
                                    //To-do add callback to reload main page
                                }else {
                                    self.errorHandle(error: "Something went wrong, please try again.")
                                }
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
    
    func errorHandle(error:String){
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(doneAction)
        self.present(alert, animated: true, completion: nil)
    }

}

extension SearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        
        if(searchText != ""){
            let session = URLSession.shared
            
            var request = URLRequest(url: CpMobileApi.searchUserUrl!)
            request.httpMethod = "POST"
            
            let params = "sessionid=\(self.sessionId)&keyword=\(searchText)"
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
                            print(json)
                            DispatchQueue.main.async {
                                if(json["type"] as! String == "error"){
                                    self.errorHandle(error: json["content"] as! String)
                                }else if(json["type"] as! String == "userList"){
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
    }
}
