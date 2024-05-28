//
//  MainScreenView.swift
//  WeeklyAssignment7
//
//  Created by Vishaq Jayakumar on 3/17/24.
//

import UIKit

class MainScreenView: UIView {
    var profilePic: UIImageView!
    var labelText: UILabel!
    var floatingButtonAddNote: UIButton!
    var tableViewNotes: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupProfilePic()
        setupLabelText()
        setupFloatingButtonAddNote()
        setupTableViewNotes()
        initConstraints()
        setupProfileTapGesture()
    }
    
    //MARK: initializing the UI elements...
    func setupProfilePic(){
        profilePic = UIImageView()
        profilePic.image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysOriginal)
        profilePic.contentMode = .scaleToFill
        profilePic.clipsToBounds = true
        profilePic.layer.masksToBounds = true
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profilePic)
    }
    
    func setupLabelText(){
        labelText = UILabel()
        labelText.font = .boldSystemFont(ofSize: 14)
        labelText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelText)
    }
    
    func setupTableViewNotes(){
        tableViewNotes = UITableView()
        tableViewNotes.register(NotesTableViewCell.self, forCellReuseIdentifier: Configs.tableViewNotesID)
        tableViewNotes.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewNotes)
    }
    
    func setupProfileTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(tapGesture)
    }
    
    @objc func profileTapped() {
        // Notify the ViewController that the profile picture is tapped
        NotificationCenter.default.post(name: NSNotification.Name("profilePicTapped"), object: nil)
    }
    
    func setupFloatingButtonAddNote(){
        floatingButtonAddNote = UIButton(type: .system)
        floatingButtonAddNote.setTitle("", for: .normal)
        floatingButtonAddNote.setImage(UIImage(systemName: "person.crop.circle.fill.badge.plus")?.withRenderingMode(.alwaysOriginal), for: .normal)
        floatingButtonAddNote.contentHorizontalAlignment = .fill
        floatingButtonAddNote.contentVerticalAlignment = .fill
        floatingButtonAddNote.imageView?.contentMode = .scaleAspectFit
        floatingButtonAddNote.layer.cornerRadius = 16
        floatingButtonAddNote.imageView?.layer.shadowOffset = .zero
        floatingButtonAddNote.imageView?.layer.shadowRadius = 0.8
        floatingButtonAddNote.imageView?.layer.shadowOpacity = 0.7
        floatingButtonAddNote.imageView?.clipsToBounds = true
        floatingButtonAddNote.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(floatingButtonAddNote)
    }
    
    
    //MARK: setting up constraints...
    func initConstraints(){
        NSLayoutConstraint.activate([
            profilePic.widthAnchor.constraint(equalToConstant: 32),
            profilePic.heightAnchor.constraint(equalToConstant: 32),
            profilePic.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            profilePic.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            labelText.topAnchor.constraint(equalTo: profilePic.topAnchor),
            labelText.bottomAnchor.constraint(equalTo: profilePic.bottomAnchor),
            labelText.leadingAnchor.constraint(equalTo: profilePic.trailingAnchor, constant: 8),
            
            tableViewNotes.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 8),
            tableViewNotes.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableViewNotes.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewNotes.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            floatingButtonAddNote.widthAnchor.constraint(equalToConstant: 48),
            floatingButtonAddNote.heightAnchor.constraint(equalToConstant: 48),
            floatingButtonAddNote.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            floatingButtonAddNote.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

