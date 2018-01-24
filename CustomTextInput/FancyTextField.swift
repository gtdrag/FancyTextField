//
//  FancyTextInput.swift
//  CustomTextInput
//
//  Created by George Drag on 1/17/18.
//  Copyright © 2018 Red Foundry. All rights reserved.
//
// ******* Inspectable keyboard types *********
//0: default // Default type for the current input method.
//1: asciiCapable // Displays a keyboard which can enter ASCII characters
//2: numbersAndPunctuation // Numbers and assorted punctuation.
//3: URL // A type optimized for URL entry (shows . / .com prominently).
//4: numberPad // A number pad with locale-appropriate digits (0-9, ۰-۹, ०-९, etc.). Suitable for PIN entry.
//5: phonePad // A phone pad (1-9, *, 0, #, with letters under the numbers).
//6: namePhonePad // A type optimized for entering a person's name or phone number.
//7: emailAddress // A type optimized for multiple email address entry (shows space @ . prominently).
//8: decimalPad // A number pad with a decimal point.
//9: twitter // A type optimized for twitter text entry (easy access to @ #)

import UIKit

@objc public protocol FancyTextFieldDelegate {
    @objc optional func fancyTextFieldShouldReturn(fancyTextField: FancyTextField)
    @objc optional func fancyTextFieldDidBeginEditing(fancyTextField: FancyTextField)
    @objc optional func fancyTextFieldDidChange(fancyTextField: FancyTextField)
    @objc optional func fancyTextFieldShouldEndEditing(fancyTextField: FancyTextField)
}

@IBDesignable
public class FancyTextField: UIView, UITextFieldDelegate {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var lineView: UIView!
    @IBOutlet var lineViewWidth: NSLayoutConstraint!
    @IBOutlet var placeHolderTextLabel: UILabel!
    @IBOutlet var placeholderTextLeading: NSLayoutConstraint!
    @IBOutlet var textFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet var labelBottomConstraint: NSLayoutConstraint!
    
    enum validationState {
        case none
        case valid
        case invalid
    }
    
    private var shouldResize = false
    private var selected = false
    public var text: String?
    private var rotation: Int?
    var delegate:FancyTextFieldDelegate?
    var valid = validationState.none {
        willSet {
            updateView(selected: self.selected)
        }
    }
    
    @IBInspectable
    var keyboardType:Int = 0 {
        didSet{
            if !(0...9).contains(keyboardType) {
                keyboardType = 0
            }
            self.textField.keyboardType = UIKeyboardType(rawValue: keyboardType)!
        }
    }
    
    @IBInspectable
    var placeholderText: String = "" {
        didSet {
            updateView(selected: self.selected)
        }
    }
    
    @IBInspectable
    var placeholderTextColor: UIColor = .darkGray {
        didSet {
            updateView(selected: self.selected)
        }
    }
    
    @IBInspectable
    var inputTextColor: UIColor = .black {
        didSet {
            updateView(selected: self.selected)
        }
    }
    
    @IBInspectable
    var underlineColor: UIColor = .blue {
        didSet {
            updateView(selected: self.selected)
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
        self.rotation = self.traitCollection.verticalSizeClass.rawValue
        self.clipsToBounds = truet
    }
    
    // in order to react to device rotation
    override open func layoutSubviews() {
        super.layoutSubviews()
        if self.rotation != self.traitCollection.verticalSizeClass.rawValue {
            self.rotation = self.traitCollection.verticalSizeClass.rawValue
            animateUnderline(focus: selected)
        }
    }
    
    fileprivate func updateView(selected: Bool) {
        placeHolderTextLabel.text = placeholderText
        placeHolderTextLabel.textColor = placeholderTextColor
        textField.textColor = inputTextColor
        switch valid {
        case .invalid:
            lineView.layer.backgroundColor = UIColor.red.cgColor
        case .valid:
            lineView.layer.backgroundColor = UIColor.green.cgColor
        default:
            lineView.layer.backgroundColor = underlineColor.cgColor
        }
        animateUnderline(focus: selected)
        if shouldResize {
            doResizeAnimation(focus: selected)
        }
    }
    
    // MARK:- ---> UITextFieldDelegate Methods
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.fancyTextFieldDidBeginEditing?(fancyTextField: self)
        self.selected = true
        updateView(selected: self.selected)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.fancyTextFieldShouldReturn?(fancyTextField: self)
        self.selected = false
        self.endEditing(true)
        updateView(selected: self.selected)
        guard let text = textField.text else { return true }
        if text.isEmpty {
            doResizeAnimation(focus: false)
        }
        return true
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.delegate?.fancyTextFieldShouldEndEditing?(fancyTextField: self)
        self.selected = false
        self.endEditing(true)
        self.shouldResize = false
        updateView(selected: self.selected)
        guard let text = textField.text else { return true }
        if text.isEmpty {
            doResizeAnimation(focus: false)
        }
        return true
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        text = textField.text
        self.delegate?.fancyTextFieldDidChange?(fancyTextField: self)
        self.selected = true
        updateView(selected: self.selected)
        guard let text = textField.text else { return }
        if text.count == 1 {
            doResizeAnimation(focus: true)
        }
    }
    
    fileprivate func animateUnderline(focus: Bool) {
        self.lineViewWidth.constant = focus ? self.layer.frame.width : 0
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    fileprivate func doResizeAnimation(focus: Bool) {
        self.shouldResize = focus ? true : false
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

