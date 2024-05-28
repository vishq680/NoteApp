//
//  ProfileViewController.swift
//  WeeklyAssignment7
//
//  Created by Vishaq Jayakumar on 3/20/24.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController {
    
    var profileView: ProfileView!

    override func loadView() {
        profileView = ProfileView()
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserProfile()
    }
    
    func fetchUserProfile() {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            // Handle missing access token
            return
        }
        
        let headers: HTTPHeaders = [
            "x-access-token": accessToken
        ]
        
        AF.request("\(APIConfigs.baseURL)auth/me", headers: headers)
            .validate()
            .responseDecodable(of: UserProfile.self) { response in
                switch response.result {
                case .success(let userProfile):
                    self.profileView.update(with: userProfile)
                case .failure(let error):
                    print("Failed to fetch user profile: \(error)")
                    // Handle error
                }
            }
    }
}
