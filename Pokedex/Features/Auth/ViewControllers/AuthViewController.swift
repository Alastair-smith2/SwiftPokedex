//
//  AuthViewController.swift
//  Pokdex
//
//  Created by Alastair Smith on 16/10/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import UIKit

enum FieldTags: Int {
    case username = 1
    case password = 2
    case usernameError = 3
    case passwordError = 4
    case submitError = 5
}

class AuthViewController: UIViewController, Storyboarded {
    var userController: UserModelController?
    weak var coordinator: MainCoordinator?

    @IBOutlet var authView: AuthView!

    override func viewDidLoad() {
        super.viewDidLoad()
        authView.userNameTextField.delegate = self
        authView.passwordTextField.delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        // Do any additional setup after loading the view.
        authView.userNameTextField.tag = FieldTags.username.rawValue
        authView.passwordTextField.tag = FieldTags.password.rawValue
        authView.userNameTextField.clearButtonMode = .whileEditing
        authView.passwordTextField.clearButtonMode = .whileEditing
        authView.userNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        authView.passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        authView.submitButton.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction func submitLogin(_: UIButton) {
        authView.userNameTextField.resignFirstResponder()
        authView.passwordTextField.resignFirstResponder()
        guard let username = self.authView.userNameTextField.text,
            let password = self.authView.passwordTextField.text else {
            return
        }
        removeErrorState()

        userController?.handleAuth(username, password) { result in
            switch result {
            case .success:
                self.coordinator?.navigate(to: .home)
                self.clearText()
            case .failure:
                self.addErrorLabel("Invalid details", wrongField: "invalid")
            }
        }
    }

    func clearText() {
        authView.userNameTextField.text = ""
        authView.passwordTextField.text = ""
    }

    func addErrorLabel(_ content: String, wrongField field: String) {
        let label: UILabel = addErrorLabel(content)
        switch field {
        case "username":
            updateUserNameFieldError(label)
        case "password":
            updatePasswordFieldError(label)
        case "invalid":
            updateSubmitError(label)
        default:
            return
        }
    }

    func updateUserNameFieldError(_ label: UILabel) {
        addErrorBorder(authView.userNameTextField)
        label.tag = FieldTags.usernameError.rawValue
        label.accessibilityIdentifier = "usernameErrorLabel"
        authView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.authView.userNameTextField.bottomAnchor, constant: 2),
            label.leadingAnchor.constraint(equalTo: self.authView.userNameLabel.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: self.authView.passwordLabel.topAnchor, constant: -10),
            label.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    func updatePasswordFieldError(_ label: UILabel) {
        addErrorBorder(authView.passwordTextField)
        label.tag = FieldTags.passwordError.rawValue
        authView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.authView.passwordTextField.bottomAnchor, constant: 2),
            label.leadingAnchor.constraint(equalTo: self.authView.passwordLabel.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: self.authView.submitButton.topAnchor, constant: -10),
            label.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    func updateSubmitError(_ label: UILabel) {
        label.tag = FieldTags.submitError.rawValue
        authView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.authView.submitButton.bottomAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: self.authView.centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    func removeErrorState() {
        let tagsToCheck: [Int] = [3, 4, 5]
        for tag in tagsToCheck {
            checkErrorState(tag)
        }
    }

    func checkErrorState(_ tag: Int) {
        switch tag {
        case 3:
            guard let userNameText = self.authView.userNameTextField.text?.count else {
                return
            }
            if let errorLabel = self.authView.viewWithTag(tag), textLongEnough(userNameText) == true {
                errorLabel.removeFromSuperview()
                authView.userNameTextField.layer.borderColor = UIColor.lightGray.cgColor
                authView.userNameTextField.layer.borderWidth = 0.5
            }
        case 4:
            guard let passwordText = self.authView.passwordTextField.text?.count else {
                return
            }
            if let errorLabel = self.authView.viewWithTag(tag), textLongEnough(passwordText) == true {
                errorLabel.removeFromSuperview()
                authView.passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
                authView.passwordTextField.layer.borderWidth = 0.5
            }
        case 5:
            if let errorLabel = self.authView.viewWithTag(tag) {
                errorLabel.removeFromSuperview()
            }
        default:
            return
        }
    }

    func addErrorLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.textColor = .red
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func addErrorBorder(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
    }

    func textLongEnough(_ count: Int) -> Bool {
        return count >= userControllerTextLengthRequired() ? true : false
    }

    func userControllerTextLengthRequired() -> Int {
        return userController?.passwordLength ?? 8
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AuthViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, textLongEnough(text.count) {
            checkErrorState(textField.tag)
            if textField.tag == 2 {
                authView.submitButton.isEnabled = true
            }
        }
    }

    func textValidationDetails() -> (Int, Int, Int) {
        let textLength = userControllerTextLengthRequired()
        let userNameLength = authView.userNameTextField.text?.count ?? 0
        let passwordLength = authView.passwordTextField.text?.count ?? 0
        return (textLength, userNameLength, passwordLength)
    }

    func textFieldShouldReturn(_: UITextField) -> Bool {
        let (textLength, userNameLength, passwordLength) = textValidationDetails()
        if authView.userNameTextField.isFirstResponder && userNameLength >= textLength {
            authView.passwordTextField.becomeFirstResponder()
            removeErrorState()
        } else if userNameLength < textLength {
            addErrorLabel("Invalid username", wrongField: "username")
        } else if authView.passwordTextField.isFirstResponder && passwordLength >= textLength {
            authView.passwordTextField.resignFirstResponder()
            removeErrorState()
            authView.submitButton.isEnabled = true
        } else {
            addErrorLabel("Password too short", wrongField: "password")
        }
        return true
    }

    @objc func keyboardWillShow(_: Notification) {
        authView.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(_: Notification) {
        authView.frame.origin.y = 0 // Move view to original position
    }
}
