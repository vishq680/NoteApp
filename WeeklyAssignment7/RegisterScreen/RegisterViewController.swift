//
//  RegisterViewController.swift
//  WeeklyAssignment7
//
//  Created by Vishaq Jayakumar on 3/17/24.
//

import UIKit
import Alamofire

struct RegisterResponse: Decodable {
    let auth: Bool
    let token: String
}

class RegisterViewController: UIViewController {
    
    let registerView = RegisterView()
    
    //    let childProgressView = ProgressSpinnerViewController()
    
    override func loadView() {
        view = registerView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        registerView.buttonRegister.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
        title = "Register"
    }
    
    @objc func onRegisterTapped(){
        //MARK: creating a new user on Firebase...
        guard let name = registerView.textFieldName.text, !name.isEmpty,
              let email = registerView.textFieldEmail.text, !email.isEmpty,
              let password = registerView.textFieldPassword.text, !password.isEmpty else {
            // Display alert for empty fields
            print("Please fill in all fields")
            showAlert(title: "Error", message: "Please fill in all fields")
            return
        }
        guard isValidEmail(email) else {
            // Display alert for invalid email format
            print("Please enter a valid email address")
            showAlert(title: "Error", message: "Please enter a valid email address")
            return
        }
        let user = User(name: name, email: email, password: password)
        addANewUser(user: user)
    }
    
    func addANewUser(user: User) {
        if let url = URL(string: APIConfigs.baseURL + "auth/register") {
            AF.request(url, method: .post, parameters: [
                "name": user.name,
                "email": user.email,
                "password": user.password
            ]).responseDecodable(of: RegisterResponse.self) { response in
                switch response.result {
                case .success(let registerResponse):
                    // Registration successful, handle the authentication token
                    UserDefaults.standard.set(registerResponse.token, forKey: "accessToken")
                    // Optionally, you can perform additional actions here after successful registration
                    self.navigationController?.popViewController(animated: true)
                    
                case .failure(let error):
                    print("Registration failed: \(error)")
                }
            }
        } else {
            // Handle invalid URL
            print("Invalid URL")
        }
    }
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    // Function to display alert
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
}
