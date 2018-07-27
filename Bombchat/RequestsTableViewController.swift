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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("friendRequests").observe(.childAdded) { (snapshot) in
            if let dataDictionary = snapshot.value as? NSDictionary{
                if let email = dataDictionary["from"] as? String {
                    
                    self.userRequestsArray.append(email)
                    self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if !userRequestsArray.isEmpty{
            print(userRequestsArray)
        cell.textLabel?.text = userRequestsArray[indexPath.row]
        }
        cell.textLabel?.textColor = UIColor.white
        

        return cell
    }
 


}
