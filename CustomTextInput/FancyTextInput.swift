//
//  FancyTextInput.swift
//  CustomTextInput
//
//  Created by George Drag on 1/17/18.
//  Copyright © 2018 Red Foundry. All rights reserved.
//

import UIKit

class FancyTextInput: UIView, UITextFieldDelegate {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var lineView: UIView!
    @IBOutlet var lineViewWidth: NSLayoutConstraint!
    
    @IBInspectable
    var placeholderText: String = "" {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var placeholderTextColor: UIColor = .black {
        didSet {
            updateView()
        }
    }
    
    fileprivate func updateView() {
        textField.text = placeholderText
        textField.textColor = placeholderTextColor
        textField.setLeftPaddingPoints(15)
    }
    
    // MARK:- ---> UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        print("TextField did begin editing method called")
        animateUnderline()
    }

    func animateUnderline() {
        self.lineViewWidth.constant = self.frame.width
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("FancyView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textField.delegate = self
    }
    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
