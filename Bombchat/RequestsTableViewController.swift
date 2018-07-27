//
//  RequestsTableViewController.swift
//  Bombchat
//
//  Created by Mohaned Al-Feky on 7/27/18.
//  Copyright © 2018 mohaned. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class RequestsTableViewController: UITableViewController {
    var userRequestsArray = [String]()
    
    @IBOutlet weak var barItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("friendRequests").observe(.childAdded) { (snapshot) in
            if let dataDictionary = snapshot.value as? NSDictionary{
                if let email = dataDictionary["from"] as? String {
                    
                    self.userRequestsArray.append(email)
                    self.tableView.reloadData()
                    self.barItem.badgeValue = String(self.userRequestsArray.count)
                }
                
            }
            
        }
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("friendRequests").observe(.childRemoved) { (snapshot) in
            if let dataDictionary = snapshot.value as? NSDictionary{
                if let email = dataDictionary["from"] as? String {
                    var index = 0
                    for em in self.userRequestsArray{
                        if em == email{
                            self.userRequestsArray.remove(at: index)
                        }
                        index += 1
                    }
                    self.tableView.reloadData()
                    self.barItem.badgeValue = String(self.userRequestsArray.count)
                    Database.database().reference().removeAllObservers()
                }
                
            }
            
        }
    }
    
    
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userRequestsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RequestsTableViewCell
        if !userRequestsArray.isEmpty{
            print(userRequestsArray)
            cell.label.text = userRequestsArray[indexPath.row]
            cell.acceptButton.tag = indexPath.row
            cell.rejectButton.tag = indexPath.row
            cell.acceptButton.addTarget(self, action: #selector(RequestsTableViewController.acceptPressed(sender:)), for: .touchUpInside)
            cell.rejectButton.addTarget(self, action: #selector(RequestsTableViewController.rejectPressed(sender:)), for: .touchUpInside)
            
        }
        
        
        
        return cell
    }
    
    @objc func acceptPressed(sender: UIButton){
        let buttonTag = sender.tag
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("friends").childByAutoId().child("email").setValue(userRequestsArray[buttonTag])
        
        Database.database().reference().child("users").queryOrdered(byChild: "email").queryEqual(toValue: userRequestsArray[buttonTag]).observe(DataEventType.childAdded) { (snapshot) in
            Database.database().reference().child("users").child(snapshot.key).child("friends").childByAutoId().child("email").setValue(Auth.auth().currentUser?.email)
        }
        
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("friendRequests").queryOrdered(byChild: "from").queryEqual(toValue: userRequestsArray[buttonTag]).observe(.childAdded) { (snapshot) in
            
                print(snapshot.key)
            Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("friendRequests").child(snapshot.key).removeValue()
            
        }
        let indexPath = [IndexPath(row: buttonTag, section: 0)]
        self.userRequestsArray.remove(at: buttonTag)
        self.tableView.deleteRows(at: indexPath, with: .fade)
        
        
    }
    @objc func rejectPressed(sender: UIButton){
        let buttonTag = sender.tag
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("friendRequests").queryOrdered(byChild: "from").queryEqual(toValue: userRequestsArray[buttonTag]).observe(.childAdded) { (snapshot) in
            Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("friendRequests").child(snapshot.key).removeValue()
            let indexPath = [IndexPath(row: buttonTag, section: 0)]
            self.userRequestsArray.remove(at: buttonTag)
            self.tableView.deleteRows(at: indexPath, with: .fade)
            
        }
        
    }
    
    
    
}
