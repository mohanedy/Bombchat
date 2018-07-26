//
//  SearchViewController.swift
//  Bombchat
//
//  Created by Mohaned Al-Feky on 7/26/18.
//  Copyright © 2018 mohaned. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class SearchViewController: UIViewController, UISearchBarDelegate {
    
    var userID = ""
    var alreadyAdded = false
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        addButton.isEnabled = false
        emailLabel.text = "Make sure to enter the right email"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let email = searchBar.text {
            (Database.database().reference().child("users").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                if let friendDictionary =  snapshot.value as? NSDictionary{
                    
                    if let userEmail = friendDictionary["email"] as? String{
                        self.emailLabel.text = userEmail
                        self.addButton.isEnabled = true
                        self.userID = snapshot.key
                   
                    }
                }else{
                  
                    
                }
            }))
            
            
            
            
        }
    }
    
    @IBAction func addPressed(_ sender: Any) {
        
        if userID != "" {
            Database.database().reference().child("users").child(userID).child("friendRequests").queryOrdered(byChild: "from").queryEqual(toValue: Auth.auth().currentUser?.email!).observeSingleEvent(of:.childAdded) { (snapshot) in
                if snapshot.exists() {
                    print("exist")
                    self.displayAlert(title: "Error", message: "You Have Request Already 😅")
                    self.alreadyAdded = true
                }
                
            }
            Database.database().reference().child("users").child(userID).child("friends").queryOrdered(byChild: "email").queryEqual(toValue: Auth.auth().currentUser?.email!).observe(.childAdded) { (snapshot) in
                if snapshot.exists(){
                    print("exist")
                    self.displayAlert(title: "Error", message: "You Are Already Friends 😇")
                    self.alreadyAdded = true
                }
                
            }
            if (alreadyAdded == false){
            Database.database().reference().child("users").child(self.userID).child("friendRequests").childByAutoId().child("from").setValue(Auth.auth().currentUser?.email!)
                self.displayAlert(title: "Done !", message: "Request is sent 😎")
                
            }
            
        }else{
            
            self.displayAlert(title: "Error", message: "Make Sure that the email exist")
            
        }
        
        
        
    }
    
    
    
}
