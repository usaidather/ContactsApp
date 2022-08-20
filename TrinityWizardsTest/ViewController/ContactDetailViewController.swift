//
//  ContactDetailViewController.swift
//  TrinityWizardsTest
//
//  Created by Usaid Ather on 20/08/2022.
//

import UIKit
// MARK: - Delegate methods.
protocol SaveContactDelegate {
    func updatedData(contact:Contact?, index: Int?)
}

class ContactDetailViewController: UIViewController {
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var avatarView: UIView!
    
    var contact : Contact? = nil
    var delegate: SaveContactDelegate?
    var index: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assigningDelegatesToTextField()
        self.prefilledTextField()
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
        self.setupAvatarRoundView()
    }
    
    //MARK: - Custom Functions
    // if from contact tapped to prefilled the fields.
    private func prefilledTextField(){
        self.firstNameTextField.text = contact?.firstName
        self.lastNameTextField.text = contact?.lastName
        self.phoneTextField.text = contact?.phone
        self.EmailTextField.text = contact?.email
    }
    
    private func assigningDelegatesToTextField(){
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.phoneTextField.delegate = self
        self.EmailTextField.delegate = self
    }
    
    // adding navigation bar button
    private func setupNavBar(){
        let saveBarButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem  = saveBarButton
        
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem  = cancelBarButton
    }
    
    // making rounded view for avatar
    private func setupAvatarRoundView(){
        self.avatarView.layer.borderWidth = 1.0
        self.avatarView.layer.masksToBounds = false
        self.avatarView.layer.borderColor = UIColor.white.cgColor
        self.avatarView.layer.cornerRadius = self.avatarView.frame.size.width / 2
        self.avatarView.clipsToBounds = true
        
        self.navigationController?.navigationBar.tintColor = .systemOrange
    }
    
    // MARK: - Navigation Bar Buttons Actions
    
    @objc func save(){
        if(!self.firstNameTextField.text!.isEmpty && !self.firstNameTextField.text!.isEmpty){
            // if from tapped contact the store updatd contact to contact model
            if var contact = contact {
                contact.lastName = self.lastNameTextField.text!
                contact.firstName = self.firstNameTextField.text!
                contact.phone = self.phoneTextField!.text!
                contact.email = self.EmailTextField!.text
                self.delegate?.updatedData(contact: contact, index:index )
            }
            else{
                //create a new model and save it to data.
                let contact = Contact.init(id: UUID().uuidString, firstName: self.firstNameTextField.text!, lastName: self.lastNameTextField.text!, email: self.EmailTextField.text!, phone: self.phoneTextField.text!)
                self.delegate?.updatedData(contact: contact, index:index )
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func cancel(){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TextField delegate

extension ContactDetailViewController:UITextFieldDelegate {
    // implement next functionality of textfields.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.firstNameTextField {
            textField.resignFirstResponder()
            self.lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            textField.resignFirstResponder()
            self.EmailTextField.becomeFirstResponder()
        } else if textField == self.EmailTextField {
            textField.resignFirstResponder()
            self.phoneTextField.becomeFirstResponder()
        }
        else if textField == self.phoneTextField {
            textField.resignFirstResponder()
            save()
        }
        return true
    }
}
