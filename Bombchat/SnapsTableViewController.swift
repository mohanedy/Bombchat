//
//  SnapsTableViewController.swift
//  Bombchat
//
//  Created by Mohaned Al-Feky on 7/24/18.
//  Copyright © 2018 mohaned. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class SnapsTableViewController: UITableViewController {
    var snaps: [DataSnapshot] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(.childAdded) { (snapshot) in
            self.snaps.append(snapshot)
            self.tableView.reloadData()
            Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(.childRemoved, with: { (snapshot) in
                var index = 0
                for snap in self.snaps{
                    if snapshot.key == snap.key{
                        
                        self.snaps.remove(at: index)
                        
                    }
                    
                    index += 1
                }
                self.tableView.reloadData()
            })
            
        }
        
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
        if snaps.count == 0 {
            return 1
        }else{
            return snaps.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if snaps.count != 0{
        let snap = snaps[indexPath.row]
        if let snapDictionary = snap.value as? NSDictionary{
            if let fromEmail = snapDictionary["from"] as? String{
                cell.textLabel?.text = fromEmail
                
            }
            
        }
        }else{
            cell.textLabel?.text = "You Have No Bomb Messages 😢"
            cell.selectionStyle = .none
        }
        cell.textLabel?.textColor = UIColor.white
        // Configure the cell...
        
        return cell
    }
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  snaps.count != 0 {
        performSegue(withIdentifier: "ViewSnapSegue", sender: snaps[indexPath.row])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewSnapSegue"{
            if let viewVC = segue.destination as? ViewSnapViewController {
                if let snap = sender as? DataSnapshot{
                    viewVC.snap = snap
                    
                }
                
            }
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
}
