//
//  ContentViewController.swift
//  PlanFrame
//
//  Created by Jkookoo on 11/05/2019.
//  Copyright © 2019 Jkookoo. All rights reserved.
//

import UIKit

protocol sendBackDelegate {
    func dataReceived(data: Plan)
    func dataRemove(index: Int)
}

class ContentViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    var newPlan: Plan?
    var oldPlan: Plan?
    var savedTime: String?
    var index: Int?
    var sendBackDelegate: sendBackDelegate?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var purposeTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
//    func alert() {
//        let alertControlloer: UIAlertController = UIAlertController(title: "Error", message: "입력!", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "입력해주세요", style: .cancel)
//
//        alertControlloer.addAction(okAction)
//        self.present(alertControlloer, animated: true, completion: nil)
//    }
    
    func placeholderOfContentView() -> NSAttributedString {
        let contentPlaceholderString = "content"
        let attribute = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        let attributedString = NSAttributedString(string: contentPlaceholderString, attributes: attribute)
        return attributedString
    }
    
    func checkPlaceholderInTextView() -> Bool {
        return (self.contentTextView.text == "content" && self.contentTextView?.textColor == UIColor.lightGray) || self.contentTextView.text == ""
    }

    func checkChanged(newPlan: Plan) -> Bool {
        return self.oldPlan?.content != newPlan.content || self.oldPlan?.title != newPlan.title || self.oldPlan?.purpose != newPlan.purpose
    }
    
    func savedPlan() {
        if let title = self.oldPlan?.title {
            self.titleTextField.text = title
        }
        
        if let purpose = self.oldPlan?.purpose {
            self.purposeTextField.text = purpose
        }
        
        if let content = self.oldPlan?.content {
            self.contentTextView.text = content
        }
    }
    
    func savePlan() {
        var newPlan: Plan = Plan()
        newPlan.title = self.titleTextField.text
        newPlan.purpose = self.purposeTextField.text
        if self.checkPlaceholderInTextView() {
            newPlan.content = nil
        } else {
            newPlan.content = self.contentTextView.text
        }
        newPlan.recentCorrectTime = self.timeFormatter()
        if checkChanged(newPlan: newPlan) {
            self.newPlan = newPlan
        }
    }
    
    func titleName() {
        self.navigationItem.title = self.titleTextField.text
        if self.navigationItem.title == "" {
            self.navigationItem.title = "Title"
        }
    }
    
    func timeFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "kr_KR")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.dateFormat = "yyyyMMdd HH:mm:ss"
        
        let date = Date()
        return dateFormatter.string(from: date)
    }
    
    func delegate() {
        self.contentTextView.delegate = self
        self.titleTextField.delegate = self
        self.purposeTextField.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        titleName()
        self.savePlan()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.doneButton.isEnabled = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.doneButton.isEnabled = true
        if self.checkPlaceholderInTextView() {
            self.contentTextView.text = ""
            self.contentTextView.textColor = UIColor.black
            self.contentTextView.font = contentTextView.font?.withSize(25)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.contentTextView.text == "" {
            self.contentTextView.attributedText = self.placeholderOfContentView()
        }
        self.savePlan()
    }
    
    @IBAction func editingDone(_ sender: UIBarButtonItem) {
        self.savePlan()
        view.endEditing(true)
        self.doneButton.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if self.isMovingFromParent {
            self.savePlan()
            if let plan = self.newPlan, self.newPlan?.title != "" {
                if self.checkChanged(newPlan: plan) {
                    if let index = self.index {
                        self.sendBackDelegate?.dataRemove(index: index)
                    }
                    self.sendBackDelegate?.dataReceived(data: plan)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate()
        if self.oldPlan?.content == nil {
            self.contentTextView.attributedText = placeholderOfContentView()
        }
        savedPlan()

        // Do any additional setup after loading the view.
    }
}
