//
//  FriendsTableViewController.swift
//  Bombchat
//
//  Created by Mohaned Al-Feky on 7/26/18.
//  Copyright © 2018 mohaned. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class FriendsTableViewController: UITableViewController {
    var friendsArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("friends").observe(.childAdded) { (snapshot) in
            if let dataDictionary = snapshot.value as? NSDictionary{
                if let email = dataDictionary["email"] as? String {
                    
                    self.friendsArray.append(email)
                    self.tableView.reloadData()
                    
                }
                
            }
            
        }
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("friends").observe(.childRemoved) { (snapshot) in
            if let dataDictionary = snapshot.value as? NSDictionary{
                if let email = dataDictionary["email"] as? String {
                   var index = 0
                    for em in self.friendsArray{
                        if em == email{
                            self.friendsArray.remove(at: index)
                        }
                        index += 1
                    }
                    self.tableView.reloadData()
                }
                
            }
            
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friendsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = friendsArray[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        
        return cell
    }
    
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("friends").queryOrdered(byChild: "email").queryEqual(toValue: tableView.cellForRow(at: indexPath)?.textLabel?.text).observe(.childAdded) { (snapshot) in
                Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("friends").child(snapshot.key).removeValue()
                
            }
            Database.database().reference().child("users").queryOrdered(byChild: "email").queryEqual(toValue: friendsArray[indexPath.row]).observe(DataEventType.childAdded) { (snapshot) in
                let userID = snapshot.key
                Database.database().reference().child("users").child(userID).child("friends").queryOrdered(byChild: "email").queryEqual(toValue: Auth.auth().currentUser?.email).observe(.childAdded, with: { (snapshot) in
                    Database.database().reference().child("users").child(userID).child("friends").child(snapshot.key).removeValue()
                })
            }
            
            friendsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
        
        
    }
}

