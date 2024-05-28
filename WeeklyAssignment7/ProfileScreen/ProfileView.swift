//
//  ProfileView.swift
//  WeeklyAssignment7
//
//  Created by Vishaq Jayakumar on 3/20/24.
//

import UIKit

class ProfileView: UIView {
    
    var nameLabel: UILabel!
    var emailLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white // Set the background color of the view
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        emailLabel = UILabel()
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emailLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            
            emailLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 20)
        ])
    }

    func update(with userProfile: UserProfile) {
        nameLabel.text = "Name: \(userProfile.name)"
        emailLabel.text = "Email: \(userProfile.email)"
    }
}

