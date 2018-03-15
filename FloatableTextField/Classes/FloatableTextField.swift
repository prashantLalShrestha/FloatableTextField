//
//  FloatTextField.swift
//  FloatTextField
//
//  Created by Prashant Shrestha on 3/10/18.
//  Copyright © 2018 prashant. All rights reserved.
//

import UIKit

@objc public protocol FloatableTextFieldDelegate {
    @objc optional func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    @objc optional func textFieldDidBeginEditing(_ textField: UITextField)
    @objc optional func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    @objc optional func textFieldShouldClear(_ textField: UITextField) -> Bool
    @objc optional func textFieldShouldReturn(_ textField: UITextField) -> Bool
    @objc optional func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    @objc optional func textFieldDidEndEditing(_ textField: UITextField)
}

@IBDesignable public class FloatableTextField: UITextField {
    public var floatableDelegate: FloatableTextFieldDelegate?
    
    public enum State {
        case SUCCESS, FAILED, DEFAULT
    }
    
    @IBInspectable var defaultColor: UIColor = .black
    @IBInspectable var successColor: UIColor = .black
    @IBInspectable var failedColor: UIColor = .red
    
    var underlineView = UIView(frame: .zero)
    var underlineRightConstraint: NSLayoutConstraint?
    
    var headerImageView = UIImageView(frame: .zero)
    @IBInspectable var headerImage: UIImage? {
        didSet {
            headerImageView.image = headerImage
        }
    }
    var headerImageHeight: CGFloat = 0.0
    
    var footerImageButton = UIButton(frame: .zero)
    @IBInspectable var footerImage: UIImage? {
        didSet {
            footerImageButton.setBackgroundImage(footerImage, for: .normal)
        }
    }
    var onStateButtonClick: ((FloatableTextField) -> ())?
    var footerImageHeight: CGFloat = 0.0
    
    var placeholderLabel = UILabel(frame: .zero)
    var placeholderLabelLeading: NSLayoutConstraint?
    var placeholderLabelTop: NSLayoutConstraint?
    var placeholderLabelCenterY: NSLayoutConstraint?
    
    var errorLabel = UILabel(frame: .zero)
    var errorLabelHeightConstraint: NSLayoutConstraint?
    open var errorMessage: String? {
        didSet {
            self.errorLabel.alpha = 0.0
            animateUnderline {
                self.errorLabel.text = self.errorMessage
                self.liftErrorLabel()
            }
        }
    }
    
    var footerActionButton = UIButton(frame: .zero)
    var onDropdownClick: ((FloatableTextField) -> ())?
    @IBInspectable var isDropdownEnabled: Bool = false
    var dropdownHeight: CGFloat = 0.0
    
    var overlayView = UIView(frame: .zero)
    
    public var currentState: State = .DEFAULT {
        didSet {
            switch currentState {
            case .DEFAULT:
                footerImageButton.setBackgroundImage(getImageFromBundle(name: "defaultImage.png"), for: .normal)
                placeholderLabel.alpha = 0.4
                underlineView.backgroundColor = defaultColor
                errorLabel.textColor = defaultColor
            case .SUCCESS:
                footerImageButton.setBackgroundImage(getImageFromBundle(name: "successImage.png"), for: .normal)
                placeholderLabel.alpha = 1.0
                underlineView.backgroundColor = successColor
                errorLabel.textColor = successColor
            case .FAILED:
                footerImageButton.setBackgroundImage(getImageFromBundle(name: "failImage.png"), for: .normal)
                placeholderLabel.alpha = 1.0
                underlineView.backgroundColor = failedColor
                errorLabel.textColor = failedColor
            }
            self.layoutIfNeeded()
        }
    }
    
    var edges = UIEdgeInsets()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        headerImageHeight = (self.frame.height < 60) ? self.frame.height * 0.55 : 50
        footerImageHeight = (self.frame.height < 60) ? self.frame.height * 0.85 : 55
        dropdownHeight = (self.frame.height < 60) ? self.frame.height * 0.45 : 30
        self.delegate = self
        self.setState(.DEFAULT)
    }
}

// MARK: - Drawings
extension FloatableTextField {
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        drawUnderline()
        if headerImage != nil {
            drawHeaderImage()
        }
        if footerImage != nil {
            drawFooterImageButton()
        } else {
            edges.right = 2.0
        }
        drawDropDown()
        drawErrorLabel()
    }
    
    override public func drawText(in rect: CGRect) {
        super.drawText(in: rect)
        if let _ = placeholder, let textString = text, !textString.isEmpty {
            drawPlaceholder(in: rect)
            if textString != "" {
                liftUpPlaceholder()
            }
        }
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        edges.top = 4.0 + (font?.pointSize)!
        edges.bottom = 4.0
        edges.left = (headerImage != nil) ? headerImageHeight + 9.0 : 9.0
        if footerImage != nil {
            edges.right = footerImageHeight + 2.0
        }
        if isSecureTextEntry || isDropdownEnabled {
            edges.right = dropdownHeight + 2.0
        }
        if (isSecureTextEntry || isDropdownEnabled) && (footerImage != nil) {
            edges.right = footerImageHeight + 2.0 + dropdownHeight + 2.0
        }
        return UIEdgeInsetsInsetRect(bounds, edges)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, edges)
    }
    
    func drawUnderline() {
        underlineView.backgroundColor = currentState == .SUCCESS ? successColor : currentState == .FAILED ? failedColor : defaultColor
        self.addSubview(underlineView)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: underlineView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        underlineRightConstraint = NSLayoutConstraint(item: underlineView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: underlineView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let underLineHeight = NSLayoutConstraint(item: underlineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 2.0)
        NSLayoutConstraint.activate([leadingConstraint, underlineRightConstraint!, bottomConstraint, underLineHeight])
    }
    
    override public func drawPlaceholder(in rect: CGRect) {
        super.drawPlaceholder(in: rect)
        guard let font = font else { return }
        placeholderLabel.font = UIFont(name: font.fontName, size: font.pointSize)
        placeholderLabel.text = placeholder
        placeholder = nil
        placeholderLabel.textColor = defaultColor
        placeholderLabel.alpha = 0.4
        placeholderLabel.backgroundColor = UIColor.clear
        self.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        let headerConstant = (headerImage != nil) ? headerImageHeight + 7.0 : 5.0
        placeholderLabelLeading = NSLayoutConstraint(item: placeholderLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: headerConstant)
        placeholderLabelTop = NSLayoutConstraint(item: placeholderLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        placeholderLabelCenterY = NSLayoutConstraint(item: placeholderLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 5.0)
        let placeholderLabelHeight = NSLayoutConstraint(item: placeholderLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: font.pointSize)
        NSLayoutConstraint.activate([placeholderLabelLeading!, placeholderLabelCenterY!, placeholderLabelHeight])
    }
    
    func drawHeaderImage() {
        headerImageView.contentMode = .scaleAspectFit
        headerImageView.clipsToBounds = true
        self.addSubview(headerImageView)
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        let leading = NSLayoutConstraint(item: headerImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 2.0)
        let centerY = NSLayoutConstraint(item: headerImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 5.0)
        let height = NSLayoutConstraint(item: headerImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: headerImageHeight)
        NSLayoutConstraint.activate([leading, centerY, height])
        let width = NSLayoutConstraint(item: headerImageView, attribute: .width, relatedBy: .equal, toItem: headerImageView, attribute: .height, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([width])
    }
    
    func drawFooterImageButton() {
        footerImageButton.imageView?.contentMode = .scaleAspectFit
        footerImageButton.clipsToBounds = true
        footerImageButton.addTarget(self, action: #selector(self.stateButtonAction), for: .touchUpInside)
        self.addSubview(footerImageButton)
        footerImageButton.translatesAutoresizingMaskIntoConstraints = false
        let trailing = NSLayoutConstraint(item: footerImageButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let centerY = NSLayoutConstraint(item: footerImageButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        let height = NSLayoutConstraint(item: footerImageButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: footerImageHeight)
        NSLayoutConstraint.activate([trailing, centerY, height])
        let width = NSLayoutConstraint(item: footerImageButton, attribute: .width, relatedBy: .equal, toItem: footerImageButton, attribute: .height, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([width])
    }
    
    func drawDropDown() {
        footerActionButton.imageView?.contentMode = .scaleAspectFit
        if isSecureTextEntry {
            footerActionButton.setBackgroundImage(getImageFromBundle(name: "hide.png"), for: .normal)
            footerActionButton.addTarget(self, action: #selector(self.showPassword), for: .touchUpInside)
        } else {
            if isDropdownEnabled {
                drawOverlayView()
                footerActionButton.setBackgroundImage(getImageFromBundle(name: "dropDown.png"), for: .normal)
                footerActionButton.addTarget(self, action: #selector(self.dropdownAction), for: .touchUpInside)
            } else {
                return
            }
        }
        self.addSubview(footerActionButton)
        footerActionButton.translatesAutoresizingMaskIntoConstraints = false
        let footerRightConstant = (footerImage != nil) ? (footerImageHeight + 5.0) : 5.0
        let trailing = NSLayoutConstraint(item: footerActionButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -footerRightConstant)
        let centerY = NSLayoutConstraint(item: footerActionButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 5.0)
        let height = NSLayoutConstraint(item: footerActionButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: dropdownHeight)
        NSLayoutConstraint.activate([trailing, centerY, height])
        let width = NSLayoutConstraint(item: footerActionButton, attribute: .width, relatedBy: .equal, toItem: footerActionButton, attribute: .height, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([width])
    }
    
    func drawErrorLabel() {
        errorLabel.text = errorMessage
        errorLabel.font = UIFont.systemFont(ofSize: (font?.pointSize)! * 0.75)
        errorLabel.textColor = currentState == .SUCCESS ? successColor : currentState == .FAILED ? failedColor : defaultColor
        errorLabel.textAlignment = .right
        errorLabel.alpha = 0.0
        self.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        let left = NSLayoutConstraint(item: errorLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 5.0)
        let right = NSLayoutConstraint(item: errorLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -5.0)
        let bottom = NSLayoutConstraint(item: errorLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        errorLabelHeightConstraint = NSLayoutConstraint(item: errorLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: (font?.pointSize)! * 0.75)
        NSLayoutConstraint.activate([left, right, bottom, errorLabelHeightConstraint!])
    }
    
    func drawOverlayView() {
        overlayView.backgroundColor = UIColor.clear
        self.addSubview(overlayView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dropdownAction))
        overlayView.addGestureRecognizer(tapGesture)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        let left = NSLayoutConstraint(item: overlayView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let right = NSLayoutConstraint(item: overlayView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -footerImageHeight)
        let top = NSLayoutConstraint(item: overlayView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottom = NSLayoutConstraint(item: overlayView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([left, right, top, bottom])
    }
}

// MARK: - Actions
extension FloatableTextField {
    @objc func stateButtonAction() {
        onStateButtonClick?(self)
    }
    
    @objc func showPassword() {
        isSecureTextEntry = !isSecureTextEntry
        if isSecureTextEntry {
            footerActionButton.setBackgroundImage(getImageFromBundle(name: "hide.png"), for: .normal)
            self.isSecureTextEntry = true
        } else {
            footerActionButton.setBackgroundImage(getImageFromBundle(name: "show.png"), for: .normal)
            self.isSecureTextEntry = false
        }
        self.selectedTextRange = self.textRange(from: beginningOfDocument, to: beginningOfDocument)
        self.selectedTextRange = self.textRange(from: endOfDocument, to: endOfDocument)
    }
    
    @objc func dropdownAction() {
        self.superview?.endEditing(true)
        onDropdownClick?(self)
        textFieldDidBeginEditing(self)
        wait(2, action:{
            self.textFieldDidEndEditing(self)
        })
    }
    
    func wait(_ time:Int,action:(() -> Void)?){
        let when = DispatchTime.now() + .seconds(time)
        DispatchQueue.main.asyncAfter(deadline: when) {
            action!()
        }
    }
    
    public func setState(_ state: State, with message: String = "") {
        animateFooterImage {
            self.currentState = state
        }
        errorMessage = message
    }
    
    private func getImageFromBundle(name: String) -> UIImage {
        let podBundle = Bundle(for: FloatableTextField.self)
        if let url = podBundle.url(forResource: "FloatableTextField", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return UIImage(named: name, in: bundle, compatibleWith: nil)!
        }
        return UIImage()
    }
}

// MARK: - UITextFieldDelegate
extension FloatableTextField: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return floatableDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text?.isEmpty)! {
            liftUpPlaceholder()
        }
        floatableDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return floatableDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return floatableDelegate?.textFieldShouldClear?(textField) ?? true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return floatableDelegate?.textFieldShouldReturn?(textField) ?? true
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return floatableDelegate?.textFieldShouldEndEditing?(textField) ?? true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.isEmpty)! {
            liftDownPlaceholder()
        }
        if let error = errorMessage, error != "" {
            animateUnderline {
                self.liftErrorLabel()
            }
        }
        floatableDelegate?.textFieldDidEndEditing?(textField)
    }
}

// MARK: - Animations
extension FloatableTextField {
    func liftUpPlaceholder() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseIn], animations: {
            self.placeholderLabel.alpha = 1.0
            self.placeholderLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.placeholderLabelLeading?.constant = 2.0
            self.placeholderLabelCenterY?.isActive = false
            self.placeholderLabelTop?.isActive = true
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func liftDownPlaceholder() {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseIn], animations: {
            self.placeholderLabel.alpha = 0.4
            self.placeholderLabel.transform = CGAffineTransform.identity
            let headerConstant = (self.headerImage != nil) ? self.headerImageHeight + 7.0 : 5.0
            self.placeholderLabelLeading?.constant = headerConstant
            self.placeholderLabelTop?.isActive = false
            self.placeholderLabelCenterY?.isActive = true
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func liftErrorLabel() {
        self.errorLabel.frame.size.height = 0.0
        self.errorLabelHeightConstraint?.constant = 0.0
        errorLabel.alpha = 1.0
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseOut], animations: {
            self.errorLabel.frame.size.height = (self.font?.pointSize)! * 0.75
            self.errorLabelHeightConstraint?.constant = (self.font?.pointSize)! * 0.75
            self.layoutIfNeeded()
        }, completion: { _ in
            UIView.animate(withDuration: 5.0, delay: 5.0, options: [.curveEaseIn], animations: {
                self.errorLabel.alpha = 0.0
                self.layoutIfNeeded()
            }, completion: nil)
        })
    }
    
    func animateUnderline(_ completion: @escaping (() -> ())) {
        underlineView.frame.size.width = 0.0
        underlineRightConstraint?.constant = -frame.width
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.underlineView.frame.size.width = self.frame.width
            self.underlineRightConstraint?.constant = 0.0
            self.layoutIfNeeded()
        }, completion: { _ in
            completion()
        })
    }
    
    func animateFooterImage(changeImage: @escaping (() -> ())) {
        footerImageButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        footerImageButton.alpha = 0.2
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [.curveEaseIn], animations: {
            self.footerImageButton.transform = CGAffineTransform.identity
            self.footerImageButton.alpha = 1.0
            changeImage()
        }, completion: nil)
    }
}

