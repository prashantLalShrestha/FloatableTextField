//
//  ViewController.swift
//  FloatableTextField
//
//  Created by prashantLalShrestha on 03/14/2018.
//  Copyright (c) 2018 prashantLalShrestha. All rights reserved.
//

import UIKit
import FloatableTextField

class ViewController: UIViewController {

    @IBOutlet weak var username: FloatableTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKey))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKey() {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func defaultAction(_ sender: Any) {
        username.setState(.DEFAULT, with: "Default State Message")
    }
    @IBAction func successAction(_ sender: Any) {
        username.setState(.SUCCESS, with: "Success State Message")
    }
    @IBAction func failureAction(_ sender: Any) {
        username.setState(.FAILED, with: "Failure State Message")
    }
    
}

