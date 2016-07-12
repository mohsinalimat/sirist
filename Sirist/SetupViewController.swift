//
//  SetupViewController.swift
//  Sirist
//
//  Created by Rob Reinhardt on 7/8/16.
//  Copyright © 2016 RR. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {
    
    // MARK: - View Properties
    
    @IBOutlet weak var authorizeRemindersButton: UIButton!
    
    @IBOutlet weak var authenticateTodoistButton: UIButton!
    
    @IBOutlet weak var letsgoButton: UIButton!
    
    // MARK: - View Setups
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SetupViewController.updateUIFromNotification), name: "authorizationUpdate", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        updateUI()
    }
    
    // MARK: - View Updates
    
    func updateUIFromNotification() {
        updateUI()
    }
    
    func updateUI() {
        
        letsgoButton.enabled = true
        
        if APIManager.sharedInstance.hasToken() {
            disableButton(authenticateTodoistButton)
        }
        else {
            letsgoButton.enabled = false
            enableButton(authenticateTodoistButton)
        }
        
        if RemindersManager.sharedInstance.isAuthorized() {
            disableButton(authorizeRemindersButton)
        }
        else {
            letsgoButton.enabled = false
            enableButton(authorizeRemindersButton)
        }
        

        
    }
    
    // MARK: - View Intertactions & Actions
    
    @IBAction func touchRemindersAuthButton(sender: AnyObject) {
        if RemindersManager.sharedInstance.requestAuth() {
            updateUI()
        }
    }
    
    
    @IBAction func touchTodoistAuthButton(sender: AnyObject) {
        self.performSegueWithIdentifier("showAuth", sender: self)
    }
    
    

    
    @IBAction func touchLetsGo(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func disableButton(button: UIButton){
        dispatch_async(dispatch_get_main_queue()) { 
            button.enabled = false
            button.setTitle("😀", forState: UIControlState.Disabled)
        }
        

    }
    func enableButton(button: UIButton){
        dispatch_async(dispatch_get_main_queue()) {
            button.enabled = true
        }
    }
    
    // MARK: - View Cleanups
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
