//
//  FancyTextInput.swift
//  CustomTextInput
//
//  Created by George Drag on 1/17/18.
//  Copyright © 2018 Red Foundry. All rights reserved.
//

import UIKit

@IBDesignable
class FancyTextInput: UIView, UITextFieldDelegate {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var lineView: UIView!
    @IBOutlet var lineViewWidth: NSLayoutConstraint!
    @IBOutlet var placeHolderTextLabel: UILabel!
    @IBOutlet var placeholderTextLeading: NSLayoutConstraint!
    @IBOutlet var textFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet var labelBottomConstraint: NSLayoutConstraint!
    
    
    @IBInspectable
    var inputTextColor: UIColor = .black {
        didSet {
            updateView()
        }
    }
    
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
    
    @IBInspectable
    var underlineColor: UIColor = .gray {
        didSet {
            updateView()
        }
    }
    
    fileprivate func updateView() {
        placeHolderTextLabel.text = placeholderText
        textField.textColor = placeholderTextColor
        textField.setLeftPaddingPoints(15)
        placeholderTextLeading.constant = 15
        lineView.layer.backgroundColor = underlineColor.cgColor
    }
    
    // MARK:- ---> UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        animateUnderline(focus: true)
    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        animateUnderline(focus: false)
        self.endEditing(true)
        return true
    }
    
    func animateUnderline(focus: Bool) {
        self.lineViewWidth.constant = focus ? self.frame.width : 0
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    func doResizeAnmimation() {
        textField.textColor = inputTextColor
        textFieldTopConstraint.constant = self.frame.height * 0.3
        // add to bottom constraint of label
        labelBottomConstraint.constant = -(self.frame.height * 0.6)
        textField.setLeftPaddingPoints(10)
        placeholderTextLeading.constant = -1
        UIView.animate(withDuration: 0.3) {
            self.placeHolderTextLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
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
        textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if textField.text?.count == 1 {
            doResizeAnmimation()
        }
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
