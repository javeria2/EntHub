//
//  ViewController.swift
//  entHub
//
//  Created by Sanchay  Javeria on 6/29/16.
//  Copyright © 2016 SanchayJaveria. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var password: shadowTextView!
    @IBOutlet weak var email: shadowTextView!
    
    override func viewDidLoad() {
        password.delegate = self
        email.delegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*display pop-ups for the app
     @param title: title of the alert!
     @param message: alert message to be displayed!
     @param alertTitle: action message to be displayed! */
    internal func popUp(title: String, message: String, alertTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: alertTitle, style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    /* closes keyboard on pressing anywhere in the view */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /* closes keyboard on hitting return */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        /* Segues dont work in viewDidLoad they only work after all the views have appeared on the screen */
        
        if NSUserDefaults.standardUserDefaults().valueForKey(key) != nil {
            self.performSegueWithIdentifier(loginSegue, sender: self)
        }
    }
    
    @IBAction func facebookLogin(sender: UIButton!) {
        let fbManager = FBSDKLoginManager()
        
        fbManager.logInWithReadPermissions(["email"]) { (result: FBSDKLoginManagerLoginResult!, error: NSError!) in
            
            if error != nil {
                self.popUp("Facebook login failed", message: "Please try again!", alertTitle: "Okay")
            } else {
              //  let token = FBSDKAccessToken.currentAccessToken().tokenString
                print("successfully logged in with facebook!")
                let accessToken = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)

                
                FIRAuth.auth()?.signInWithCredential(accessToken, completion: { (auth, error) in
                    if error != nil {
                        self.popUp("Sign in failed", message: "pleas try to sign in again!", alertTitle: "Okay")
                    } else {
                        print("Logged in! \(auth?.providerID)")
                        
                        let user = ["provider": accessToken.provider,"name": (auth?.displayName)!, "email":(auth?.email)!]
                        
                        networkPacket.service.newUser((auth?.uid)!, users: user)
                        
                        
                        NSUserDefaults.standardUserDefaults().setValue(auth?.uid, forKey: key)
                        
                        self.performSegueWithIdentifier(loginSegue, sender: self)
                    }
                })
            }
            
        }
    }
    
    @IBAction func signUp(sender: UIButton) {
        if email.text == "" || password.text == "" {
            self.popUp("Invalid Entries", message: "Email and Password are required fileds!", alertTitle: "Got it")
            return
        } else {
            FIRAuth.auth()?.createUserWithEmail(email.text!, password: password.text!, completion: { (user, error) in
                if error != nil {
                    /* account already exists */
                    print("account already exists")
                    self.logUserIn()
                } else {
                    print("new account created")
                    NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: key)
                    self.logUserIn()
                }
            })
        }
    }
    
    func logUserIn() {
        FIRAuth.auth()?.signInWithEmail(email.text!, password: password.text!, completion: { (User, error) in
            if error != nil {
                self.popUp("Error logging in", message: "Email/Password is incorrect!", alertTitle: "Try Again")
            } else {
                let user = ["provider": "email", "name": (User?.displayName)!, "email": (User?.email)!]
                networkPacket.service.newUser((User?.uid)!, users: user)
                
                NSUserDefaults.standardUserDefaults().setValue(User?.uid, forKey: key)
                self.performSegueWithIdentifier(loginSegue, sender: self)
            }
        })
    }
}

