//
//  RightBarButtonManager.swift
//  WeeklyAssignment7
//
//  Created by Vishaq Jayakumar on 3/17/24.
//

import UIKit
import Alamofire

extension ViewController{
    func setupRightBarButton(isLoggedin: Bool){
        if isLoggedin{
            //MARK: user is logged in...
            let barIcon = UIBarButtonItem(
                image: UIImage(systemName: "rectangle.portrait.and.arrow.forward"),
                style: .plain,
                target: self,
                action: #selector(onLogOutBarButtonTapped)
            )
            let barText = UIBarButtonItem(
                title: "Logout",
                style: .plain,
                target: self,
                action: #selector(onLogOutBarButtonTapped)
            )
            
            navigationItem.rightBarButtonItems = [barIcon, barText]
            
        }else{
            //MARK: not logged in...
            let barIcon = UIBarButtonItem(
                image: UIImage(systemName: "person.fill.questionmark"),
                style: .plain,
                target: self,
                action: #selector(onSignInBarButtonTapped)
            )
            let barText = UIBarButtonItem(
                title: "Sign in",
                style: .plain,
                target: self,
                action: #selector(onSignInBarButtonTapped)
            )
            
            navigationItem.rightBarButtonItems = [barIcon, barText]
        }
        updateMainScreenUI(isLoggedIn: isLoggedin)
    }
    
    @objc func onSignInBarButtonTapped(){
        let signInAlert = UIAlertController(
            title: "Sign In / Register",
            message: "Please sign in to continue.",
            preferredStyle: .alert)
        
        //MARK: setting up email textField in the alert...
        signInAlert.addTextField{ textField in
            textField.placeholder = "Enter email"
            textField.contentMode = .center
            textField.keyboardType = .emailAddress
        }
        
        //MARK: setting up password textField in the alert...
        signInAlert.addTextField{ textField in
            textField.placeholder = "Enter password"
            textField.contentMode = .center
            textField.isSecureTextEntry = true
        }
        
        //MARK: Sign In Action...
        let signInAction = UIAlertAction(title: "Sign In", style: .default, handler: {(_) in
            if let email = signInAlert.textFields![0].text,
               let password = signInAlert.textFields![1].text{
                //MARK: sign-in logic for Firebase...
                self.signIn(alert: signInAlert, email: email, password: password)
            }
        })
        
        //MARK: Register Action...
        let registerAction = UIAlertAction(title: "Register", style: .default, handler: {(_) in
            //MARK: logic to open the register screen...
            let registerViewController = RegisterViewController()
            self.navigationController?.pushViewController(registerViewController, animated: true)
        })
        
        
        //MARK: action buttons...
        signInAlert.addAction(signInAction)
        signInAlert.addAction(registerAction)
        
        self.present(signInAlert, animated: true, completion: {() in
            //MARK: hide the alerton tap outside...
            signInAlert.view.superview?.isUserInteractionEnabled = true
            signInAlert.view.superview?.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(self.onTapOutsideAlert))
            )
        })
    }
    
    @objc func onTapOutsideAlert(){
        self.dismiss(animated: true)
    }
    
    @objc func onLogOutBarButtonTapped(){
        let logoutAlert = UIAlertController(title: "Logging out!", message: "Are you sure want to log out?", preferredStyle: .actionSheet)
        logoutAlert.addAction(UIAlertAction(title: "Yes, log out!", style: .default, handler: {(_) in
            do{
                guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
                    print("No access token found")
                    return
                }
                
                self.logout(with: accessToken)
            }catch{
                print("Error occured!")
            }
        })
        )
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(logoutAlert, animated: true)
    }
    
    func signIn(alert: UIAlertController, email: String, password: String) {
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        //        AF.request("\(APIConfigs.baseURL)post", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        
        AF.request("\(APIConfigs.baseURL)auth/login", method: .post, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any],
                       let accessToken = json["token"] as? String {
                        UserDefaults.standard.set(accessToken, forKey: "accessToken")
                        self.setupRightBarButton(isLoggedin: true) // Update UI
                        self.fetchNotes(token: accessToken)
                    } else {
                        print("Invalid response format")
                    }
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true)
                    }
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 401:
                            // Unauthorized - Incorrect credentials
                            self.showAlert(title: "Error", message: "Incorrect email or password")
                        default:
                            print("Login failed: \(error)")
                        }
                    } else {
                        print("Login failed: \(error)")
                    }
                }
            }
    }
    
    func logout(with accessToken: String) {
        let headers: HTTPHeaders = [
            "x-access-token": accessToken
        ]
        
        AF.request("\(APIConfigs.baseURL)auth/logout", headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    UserDefaults.standard.removeObject(forKey: "accessToken")
                    self.setupRightBarButton(isLoggedin: false) // Update UI
                case .failure(let error):
                    print("Logout failed: \(error)")
                }
            }
    }
    
    func updateMainScreenUI(isLoggedIn: Bool) {
        if isLoggedIn {
            // Update UI for signed-in state
            title = "My Notes"
            mainScreen.labelText.text = "Welcome \(self.currentUser?.name ?? "Anonymous")!"
            mainScreen.floatingButtonAddNote.isEnabled = true
            mainScreen.floatingButtonAddNote.isHidden = false
            mainScreen.tableViewNotes.delegate = self
            mainScreen.tableViewNotes.dataSource = self
            mainScreen.tableViewNotes.separatorStyle = .none
            navigationController?.navigationBar.prefersLargeTitles = true
            view.bringSubviewToFront(mainScreen.floatingButtonAddNote)
            mainScreen.floatingButtonAddNote.addTarget(self, action: #selector(addNoteButtonTapped), for: .touchUpInside)
        }
        else {
            // Update UI for signed-out state
            mainScreen.labelText.text = "Please sign in to see the notes!"
            mainScreen.floatingButtonAddNote.isEnabled = false
            mainScreen.floatingButtonAddNote.isHidden = true
            notesList.removeAll()
        }
        mainScreen.tableViewNotes.reloadData()
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}


