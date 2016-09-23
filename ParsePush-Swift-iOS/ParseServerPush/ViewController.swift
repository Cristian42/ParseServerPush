//
//  ViewController.swift
//  ParseServerPush
//
//  Created by Dan-Cristian Andronic on 9/23/16.
//  Copyright © 2016 Dan-Cristian Andronic. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let gameScore = PFObject(className:"GameScore")
        gameScore["score"] = 1337
        gameScore["playerName"] = "Sean Plott"
        gameScore["cheatMode"] = false
        gameScore.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Successfuly saved object to Parse Server")
            } else {
                print("Failed saving object to Parse Server")
                print(error)
            }
        }
        
        let parameters = ["channels": ["global"], "message": "Hurray!"]
        PFCloud.callFunctionInBackground("sendPushToChannels", withParameters: parameters) {
            (response: AnyObject?, error: NSError?) -> Void in
            if (error == nil) {
                print("Successfuly sent Push Notification to Parse Server")
            } else {
                print("Failed sending Push Notification to Parse Server")
                print(error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}