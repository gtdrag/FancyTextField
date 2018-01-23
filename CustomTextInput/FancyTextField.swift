//
//  FancyTextInput.swift
//  CustomTextInput
//
//  Created by George Drag on 1/17/18.
//  Copyright © 2018 Red Foundry. All rights reserved.
//

import UIKit

@objc public protocol FancyTextFieldDelegate {
    @objc optional func fancyTextFieldShouldReturn(fancyTextField: FancyTextField)
    @objc optional func fancyTextFieldDidBeginEditing(fancyTextField: FancyTextField)
    @objc optional func fancyTextFieldDidChange(fancyTextField: FancyTextField)
    @objc optional func fancyTextFieldShouldEndEditing(fancyTextField: FancyTextField)
}

@IBDesignable
open class FancyTextField: UIView, UITextFieldDelegate {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var lineView: UIView!
    @IBOutlet var lineViewWidth: NSLayoutConstraint!
    @IBOutlet var placeHolderTextLabel: UILabel!
    @IBOutlet var placeholderTextLeading: NSLayoutConstraint!
    @IBOutlet var textFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet var labelBottomConstraint: NSLayoutConstraint!
    
    var firstResized = false
    var text: String?
    var delegate:FancyTextFieldDelegate?
    
    @IBInspectable
    var placeholderText: String = "" {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var placeholderTextColor: UIColor = .darkGray {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var inputTextColor: UIColor = .black {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var underlineColor: UIColor = .blue {
        didSet {
            updateView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let podBundle = Bundle(for: FancyTextField.self)
        podBundle.loadNibNamed("FancyView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 5
    }
    
    
    fileprivate func updateView() {
        placeHolderTextLabel.text = placeholderText
        placeHolderTextLabel.textColor = placeholderTextColor
        textField.textColor = inputTextColor
        lineView.layer.backgroundColor = underlineColor.cgColor
    }
    
    // MARK:- ---> UITextFieldDelegate Methods
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        animateUnderline(focus: true)
        self.delegate?.fancyTextFieldDidBeginEditing?(fancyTextField: self)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        animateUnderline(focus: false)
        self.endEditing(true)
        if textField.text?.count == 0 {
            doResizeAnmimation(focus: false)
        }
        self.delegate?.fancyTextFieldShouldReturn?(fancyTextField: self)
        return true
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        animateUnderline(focus: false)
        self.endEditing(true)
        if textField.text?.count == 0 {
            doResizeAnmimation(focus: false)
        }
        self.delegate?.fancyTextFieldShouldEndEditing?(fancyTextField: self)
        return true
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        text = textField.text
        self.delegate?.fancyTextFieldDidChange?(fancyTextField: self)
        if !self.firstResized {
            doResizeAnmimation(focus: true)
        }
    }
    
    
    fileprivate func animateUnderline(focus: Bool) {
        self.lineViewWidth.constant = focus ? self.frame.width : 0
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    fileprivate func doResizeAnmimation(focus: Bool) {
        self.firstResized = focus ? true : false
        textFieldTopConstraint.constant = focus ? self.frame.height * 0.33 : 0
        labelBottomConstraint.constant = focus ? -self.frame.height * 0.5 : 0
        let oldFrame = self.placeHolderTextLabel.frame
        UIView.animate(withDuration: 0.3) {
            self.placeHolderTextLabel.layer.anchorPoint = CGPoint(x: focus ? 0.715 : 0.5, y: 0.5)
            self.placeHolderTextLabel.transform = CGAffineTransform(scaleX: focus ? 0.7 : 1, y: focus ? 0.7 : 1)
            self.placeHolderTextLabel.frame = oldFrame
            self.layoutIfNeeded()
        }
    }
}

