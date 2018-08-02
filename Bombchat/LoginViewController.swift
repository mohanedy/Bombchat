//
//  ViewController.swift
//  Bombchat
//
//  Created by Mohaned Al-Feky on 7/22/18.
//  Copyright © 2018 mohaned. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class LoginViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var signupOrLoginButton: UIButton!
   
    
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var signupMode = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        passwordTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signupOrLoginPressed(signupOrLoginButton)
        
        return true
    }
    
    @IBAction func signupOrLoginPressed(_ sender: UIButton) {
        if passwordTextField.text == "" || emailTextField.text == ""{
            displayAlert(title: "Error", message: "Make sure that you entered both email and password")
            
        }else{
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = .gray
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if (signupMode){
                Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if let err = error{
                        self.displayAlert(title: "Error", message: err.localizedDescription)
                   
                    }else{
                        if let user = result{
                        Database.database().reference().child("users").child(user.user.uid).child("email").setValue(user.user.email)
                         
                        
                        self.performSegue(withIdentifier: "UsersSegue", sender: self)
                        }
                    }
                }
                
            }else{
                Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if let err = error{
                       
                        self.displayAlert(title: "Error", message: err.localizedDescription)
                       
                        
                    }else{
        
                       self.performSegue(withIdentifier: "UsersSegue", sender: self)
                        
                    }
                }
                
            }
        }
        
    }
    @IBAction func switchPressed(_ sender: UIButton) {
        if (signupMode){
            signupMode = false
            signupOrLoginButton.setTitle("LOGIN", for: .normal)
            switchButton.setTitle("SWITCH TO SIGN UP", for: .normal)
            
        }else{
            
            signupMode = true
            signupOrLoginButton.setTitle("SIGN UP", for: .normal)
            switchButton.setTitle("SWITCH TO LOGIN", for: .normal)
            
        }
        
        
    }
    @IBAction func aboutPressed(_ sender: Any) {
        let alert = UIAlertController(title: "About", message: "Dev: @Mohaned_y98 ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Twitter", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            if let url = URL(string: "https://twitter.com/mohaned_y98") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    }
    
    
