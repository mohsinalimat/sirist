//
//  ViewController.swift
//  Sirist
//
//  Created by Rob Reinhardt on 7/8/16.
//  Copyright © 2016 RR. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController  {

    // MARK: - Properties
    
    @IBOutlet weak var appView: UIView!
    
    private var webView: WKWebView?
    
    // MARK: - View Setups
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if !AppDelegate().isAppAllSet() {
            self.performSegueWithIdentifier("showSetup", sender: self)
        }
    }
    
    // MARK: - View Actions

    @IBAction func touchImportReminders(sender: AnyObject) {
        RemindersManager.sharedInstance.getReminders()
    }

    // MARK: - Misc Cleanups
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

