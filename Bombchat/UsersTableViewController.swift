//
//  UsersTableViewController.swift
//  Bombchat
//
//  Created by Mohaned Al-Feky on 7/24/18.
//  Copyright © 2018 mohaned. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class UsersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    
    
    @IBAction func logoutPressed(_ sender: Any) {
        do{
            
        
           try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        }catch{
            print(error)
        }
        
    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Test"
        cell.textLabel?.textColor = UIColor.white
        // Configure the cell...

        return cell
    }
 


}
