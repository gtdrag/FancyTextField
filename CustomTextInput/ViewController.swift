//
//  ViewController.swift
//  CustomTextInput
//
//  Created by George Drag on 1/17/18.
//  Copyright © 2018 Red Foundry. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FancyTextFieldDelegate {
    @IBOutlet var firstNameInput: FancyTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameInput.delegate = self
    }
    
    func fancyTextFieldDidChange(fancyTextField: FancyTextField) {
        print("text changed: \(fancyTextField.textField.text!)")
    }

    func fancyTextFieldShouldReturn(fancyTextField: FancyTextField) {
        print("return key pressed")
    }
}

