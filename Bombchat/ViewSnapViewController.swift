//
//  ViewSnapViewController.swift
//  Bombchat
//
//  Created by Mohaned Al-Feky on 7/25/18.
//  Copyright © 2018 mohaned. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SDWebImage
import FirebaseStorage
class ViewSnapViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var snap : DataSnapshot?
    @IBOutlet weak var messageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let snapData = snap{
            if let snapDictionary = snapData.value as? NSDictionary{
                if let message = snapDictionary["message"] as? String{
                    if let imageURL = snapDictionary["imageURL"] as? String{
                        messageLabel.text = message
                        DispatchQueue.global(qos: .background).async {
                            self.imageView.sd_setImage(with: URL(string: imageURL), completed: nil)
                        }
                        
                        
                    }
                    
                }
                
            }
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("snaps").child((snap?.key)!).removeValue()
        if let snapData = snap{
            if let snapDictionary = snapData.value as? NSDictionary{
                if let imageName = snapDictionary["imageName"] as? String{
                    Storage.storage().reference().child("images").child(imageName).delete(completion: nil)
                    
                }
            }
        }
        
        
        
    }
    
    
    
    
}
