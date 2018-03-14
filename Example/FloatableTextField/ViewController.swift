//
//  ViewController.swift
//  FloatableTextField
//
//  Created by prashantLalShrestha on 03/14/2018.
//  Copyright (c) 2018 prashantLalShrestha. All rights reserved.
//

import UIKit
import FloatableTextField

class ViewController: UIViewController, FloatableTextFieldDelegate {

    @IBOutlet weak var username: FloatableTextField!
    @IBOutlet weak var passcode: FloatableTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        username.floatableDelegate = self
        passcode.floatableDelegate = self
        
        username.returnKeyType = .next
        passcode.returnKeyType = .done
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKey))
        self.view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == username {
            username.resignFirstResponder()
            passcode.becomeFirstResponder()
        } else if textField == passcode {
            passcode.resignFirstResponder()
            self.dismissKey()
        }
        return true
    }
    
    @objc func dismissKey() {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func defaultAction(_ sender: Any) {
        username.setState(.DEFAULT, with: "Default State Username Message")
        passcode.setState(.DEFAULT, with: "Default State Passcode Message")
    }
    @IBAction func successAction(_ sender: Any) {
        username.setState(.SUCCESS, with: "Success State Message")
        passcode.setState(.SUCCESS, with: "Success State Passcode Message")
    }
    @IBAction func failureAction(_ sender: Any) {
        username.setState(.FAILED, with: "Failure State Message")
        passcode.setState(.FAILED, with: "Failure State Passcode Message")
    }
    
}

