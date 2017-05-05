//
//  UCCompletionTextField.swift
//  UCCompletionTextField
//
//  Created by Mohamed on 5/05/17.
//  Copyright © 2017 mohamedz. All rights reserved.
//

import Foundation
import UIKit
import DropDown

class UCCompletionTextField: UIView {
    
    //MARK: Private properties
    
    
    fileprivate var data = [String]()
    fileprivate var dropDown = DropDown()
    fileprivate var focusedOrFilled : Bool = false

    //MARK: IBOutlets
    
    @IBOutlet weak var textFieldDelegate : UITextFieldDelegate?
    
    //MARK: Properties
    var content = [String]()
    var delegate: UCCompletionTextFieldDelegate!
    let textField : UITextField = UITextField()
    let labelPlaceHolder : UILabel = UILabel()
    var found:String?
    @IBInspectable var errorColor : UIColor = UIColor.red{
        didSet {
            self.setColors()
        }
    }
    
    var text: String {
        get {
            return textField.text ?? ""
        }
        set {
            textField.text = newValue
            textFieldActive(!newValue.isEmpty, animated: false)
            self.labelPlaceHolder.isHidden = newValue == "" ? false : true
        }
    }
    
    var isTextFieldEmpty : Bool{
        return self.text.isEmpty
    }
    
    @IBInspectable var textColor : UIColor = UIColor.darkGray {
        didSet {
            self.setColors()
            textField.tintColor = textColor
        }
    }
    
    @IBInspectable var placeholderColor : UIColor = UIColor.darkGray {
        didSet {
            self.setColors()
        }
    }
    
    @IBInspectable var placeholderActiveColor : UIColor = UIColor.darkGray {
        didSet {
            self.setColors()
        }
    }
    
    var placeHolderFont : UIFont = UIFont.systemFont(ofSize: 20) {
        didSet {
            self.labelPlaceHolder.font = placeHolderFont
        }
    }
    
    var textFont : UIFont =  UIFont.systemFont(ofSize: 20) {
        didSet {
            self.textField.font = textFont
        }
    }
    
    var owner = UIViewController()
    
    var containsError : Bool = false {
        didSet {
            self.setColors()
        }
    }
    
    //MARK: Init
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let data = self.delegate.dataForPopoverInTextField(self) {
            self.data = data
        }
        self.setupDropDownChoose()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
    }
    
    
    //MARK: Functions
    
    func clearTextField(){
        if(text.characters.count > 0 ){
            self.text = ""
            textFieldActive(false)
            self.setColors()
            labelPlaceHolder.isHidden = false
        }
        
    }
    
    //MARK: Private functions
    
    func setupDropDownChoose() {
        dropDown.setup(anchorView: self, dataSource: data)
        dropDown.selectionAction = { [unowned self] (index, item) in
            self.text = item
            if let found = self.content.find({$0 == item}){
                self.found = found
                _ = self.textFieldShouldEndEditing(self.textField)
            }else{
                self.containsError = true
            }
        }
    }
    
    fileprivate func textFieldActive(_ active : Bool, animated : Bool = true) {
        self.focusedOrFilled = active
        UIView.animate(withDuration: animated ? 0.1 : 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut.intersection(.beginFromCurrentState), animations: { () -> Void in
            if active {
                self.labelPlaceHolder.isHidden = true
            }
            self.setColors()
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    fileprivate func setColors() {
        self.labelPlaceHolder.textColor = containsError ? errorColor : focusedOrFilled ? self.placeholderColor : self.placeholderActiveColor
        self.textField.textColor =  containsError ? errorColor : self.textColor
        self.textField.tintColor = self.textColor
        self.layer.borderColor = containsError ? errorColor.cgColor : self.textColor.cgColor
    }
    
    fileprivate func fetchTextMatching(_ searchText:String, completion: @escaping (([String]) -> Void)){
        
        let data = self.content.filter { term in
            let string = term.folding(options: .diacriticInsensitive, locale: .current)
            return string.lowercased().contains(searchText.lowercased())
        }
        completion(data)
    }


    
    fileprivate func initViews() {
        self.clipsToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint = NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 13)
        let trailingConstraint = NSLayoutConstraint(item: textField, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        
        //Set spacing top to superview
        let topConstraint = NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        
        //Set spacing bottom to superview
        let bottomConstraint = NSLayoutConstraint(item: textField, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        
        self.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
        labelPlaceHolder.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelPlaceHolder)
        let yConstraint = NSLayoutConstraint(item: self.labelPlaceHolder, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yConstraint)
        let leadingConstraintPH = NSLayoutConstraint(item: labelPlaceHolder, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 13)
        self.addConstraint(leadingConstraintPH)
        
        labelPlaceHolder.text = "Placeholder"
        labelPlaceHolder.font = placeHolderFont
        textField.textColor = textColor
        textField.tintColor = textColor
        textField.backgroundColor = UIColor.clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = textFont
        textField.text = ""
        textField.font = textFont
        textField.delegate = self
        setColors()
    }
    
    
}

extension UCCompletionTextField : UITextFieldDelegate {
    
    //MARK: UITextFieldDelegate functions
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let should = textFieldDelegate?.textFieldShouldBeginEditing?(textField) ?? true
        textFieldActive(true)
        self.containsError = false
         return should
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let should = textFieldDelegate?.textFieldShouldEndEditing?(textField) ?? true
        self.containsError = !self.data.contains(self.text)
        if textField.text == nil ||  textField.text!.isEmpty {
            textFieldActive(false)
        }
        dropDown.hide()
         return should
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.labelPlaceHolder.isHidden = true
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92) { // if backSpace
            dropDown.hide()
        } else if(text.characters.count > 1){
            DispatchQueue.main.async {
                self.fetchTextMatching(self.text, completion: { (data) in
                    self.dropDown.dataSource = data
                    self.dropDown.show()
                })
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.containsError = false
        textFieldActive(true)
         textFieldDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.containsError = false
         return textFieldDelegate?.textFieldShouldClear?(textField) ?? true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldActive(false)
        dropDown.hide()
         return textFieldDelegate?.textFieldShouldReturn?(textField) ?? true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDelegate?.textFieldDidBeginEditing?(textField)
         if(textField.text!.isEmpty){
            self.labelPlaceHolder.isHidden = false
            textFieldActive(false)
        }
    }
    
}

extension DropDown{
    
    func setup(anchorView : UIView, dataSource: [String]){
        let appearance = DropDown.appearance()
        appearance.cellHeight = 60
        appearance.backgroundColor = UIColor.lightGray
        appearance.selectionBackgroundColor = UIColor.white
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.35
        appearance.textColor = UIColor.darkGray
        appearance.textFont = UIFont.systemFont(ofSize: 20)
        self.cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self))
        self.anchorView = anchorView
        self.customCellConfiguration = nil
        self.direction = .any
        self.dismissMode = .onTap
        self.dataSource = dataSource
    }
    
}


extension Collection {
    func find( _ predicate: (Self.Iterator.Element) throws -> Bool) rethrows -> Self.Iterator.Element? {
        return try index(where: predicate).map({self[$0]})
    }
}


