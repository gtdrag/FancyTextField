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
    @IBOutlet var lastNameInput: FancyTextField!
    @IBOutlet var emailInput: FancyTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameInput.delegate = self
        lastNameInput.delegate = self
        emailInput.delegate = self
    }
    
    func fancyTextFieldDidChange(fancyTextField: FancyTextField) {
        if fancyTextField.placeholderText == "Email" {
            guard let email = fancyTextField.text else { return }
            // if text changes to empty string, reset validation state to '.none'
            if email.isEmpty {
                fancyTextField.valid = .none
                // otherwise set valid or invalid based on current content
            } else {
                fancyTextField.valid = self.isValidEmail(email: email) ? .valid : .invalid
            }
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

