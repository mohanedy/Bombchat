//
//  SelectPictureViewController.swift
//  Bombchat
//
//  Created by Mohaned Al-Feky on 7/24/18.
//  Copyright © 2018 mohaned. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class SelectPictureViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker:UIImagePickerController?
    
    @IBOutlet weak var messageTextField: UITextField!
    var imageAdded = false
    var imageName = "\(NSUUID().uuidString).jpg"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        
        
    }
    
    @IBAction func cameraPressed(_ sender: Any) {
        if imagePicker != nil {
            imagePicker!.sourceType = .camera
            present(imagePicker!, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
            imageAdded = true
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func filePressed(_ sender: Any) {
        if imagePicker != nil {
            imagePicker!.sourceType = .photoLibrary
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        
        if let message = messageTextField.text {
            if (imageAdded && message != ""){
                let imagesFolder = Storage.storage().reference().child("images")
                if let image = imageView.image{
                    if let imageData =  UIImageJPEGRepresentation(image, 0.1){
                        imagesFolder.child(imageName).putData(imageData, metadata: nil) { (metadata, error) in
                            if let err = error{
                                self.displayAlert(title:"Error", message: err.localizedDescription)
                            }else{
                                if let metaDictionary = metadata?.dictionaryRepresentation(){
                                    if let name = metaDictionary["name"]{
                                        Storage.storage().reference().child("\(name)").downloadURL(completion: { (url, error) in
                                            if let err = error{
                                                self.displayAlert(title: "Error", message:err.localizedDescription)
                                            }else{
                                                if let photoUrl = url?.absoluteString{
                                                   
                                                    self.performSegue(withIdentifier: "SendToSegue", sender: photoUrl)
                                                }
                                            }
                                        })
                                    }
                                }
                                
                            }
                        }
                        
                    }
                    
                    
                }
            }else{
                self.displayAlert(title: "Error", message:"Make sure that you added a photo and typed a message")
                
            }
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectVC = segue.destination as? SelectReciverTableViewController{
            
            if let  downlod = sender as? String{
                selectVC.downloadURL = downlod
                selectVC.message = messageTextField.text!
                selectVC.imageName = imageName
            }
        }
        
    }
    
    
}
