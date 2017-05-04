//
//  ChatTableViewController.swift
//  CP Chat
//
//  Created by Pakkapol Rattanapongsen on 5/3/2560 BE.
//  Copyright © 2560 Pakkapol Rattanapongsen. All rights reserved.
//

import UIKit

class ChatTableViewController: UITableViewController {

    let limit = 50
    var seqNo = 0
    let sessionId = UserDefaults.standard.string(forKey: "sessionId")!
    
    var targetname:String?
    
    var updateTimer:Timer?
    
    @IBOutlet weak var chatBox: UITextField!
    @IBAction func sendMessage(_ sender: Any) {
        self.sendMessageHandle()
    }
    var messages:[Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.targetname!
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.chatBox.becomeFirstResponder()
        
        self.getMessage()
        
        self.updateTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: {_ in
            self.getMessage()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.updateTimer?.invalidate()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatCell

        let message = messages[indexPath.row]
        // Configure the cell...
        if(message.from != self.targetname){
            cell.textView.textAlignment = .right
            cell.timeView.textAlignment = .right
        }
        cell.textView.text = message.message
        cell.timeView.text = message.datetime
        return cell
    }
    
    func errorHandle(error:String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "Done", style: .default, handler: nil)
            alert.addAction(doneAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func sendMessageHandle(){
        let textMessage = self.chatBox.text
        let session = URLSession.shared
        
        var request = URLRequest(url: CpMobileApi.postMessageUrl!)
        request.httpMethod = "POST"
        
        let params = "sessionid=\(self.sessionId)&targetname=\(self.targetname!)&message=\(textMessage!)"
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
                            }else if(json["type"] as! String == "postMessage"){
                                let result = json["content"] as! Bool
                                if(result == true){
                                    self.getMessage()
                                    self.chatBox.text = ""
                                }else{
                                    self.errorHandle(error: "Something went wrong, please try again.")
                                }
                            }
                        }
                    }
                }
                catch { }
            }
        })
        task.resume()
    }

    func getMessage(){
        let session = URLSession.shared
        
        var request = URLRequest(url: CpMobileApi.getMessageUrl!)
        request.httpMethod = "POST"
        
        let params = "sessionid=\(self.sessionId)&seqno=\(self.seqNo)&limit=\(self.limit)"
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
                            }else if(json["type"] as! String == "getMessage"){
                                let content = json["content"] as! [[String: String]]
                                self.messages = []
                                for item in content{
                                    print(item)
                                    let message = Message(data: item)
                                    if(message.from == self.targetname || message.to == self.targetname){
                                        self.messages.append(message)
                                    }
                                }
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

struct Message{
    var seqNo:String
    var datetime:String
    var from:String
    var to:String
    var message:String
    
    init(data:[String:String]){
        self.seqNo = data["seqno"]!
        self.datetime = data["datetime"]!
        self.from = data["from"]!
        self.to = data["to"]!
        self.message = data["message"]!
    }
    
    init(){
        self.seqNo = ""
        self.datetime = ""
        self.from = ""
        self.to = ""
        self.message = ""
    }
}
