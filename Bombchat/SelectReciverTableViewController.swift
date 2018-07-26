//
//  SelectReciverTableViewController.swift
//  Bombchat
//
//  Created by Mohaned Al-Feky on 7/25/18.
//  Copyright © 2018 mohaned. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class SelectReciverTableViewController: UITableViewController {
    var downloadURL = ""
    var usersArray : [User] = []
    var message = ""
    var imageName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            let user = User()
            if let dataDictionary = snapshot.value as? NSDictionary{
                if let email = dataDictionary["email"] as? String{
                    if email != Auth.auth().currentUser?.email{
                        user.email = email
                        user.uid = snapshot.key
                        self.usersArray.append(user)
                        self.tableView.reloadData()
                    }
                }
                
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReciverCell", for: indexPath)
        let user = usersArray[indexPath.row]
        
        cell.textLabel?.text = user.email
        cell.textLabel?.textColor = UIColor.white
        // Configure the cell...
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = usersArray[indexPath.row]
        
        let snap = ["from":Auth.auth().currentUser?.email,"message":message,"imageURL":downloadURL,"imageName":imageName]
        
        Database.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snap)
        navigationController?.popToRootViewController(animated: true)
        
    }
    
}
class User {
    var email = ""
    var uid = ""
    
    
}
