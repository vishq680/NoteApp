//
//  ViewController.swift
//  WeeklyAssignment7
//
//  Created by Vishaq Jayakumar on 3/17/24.
//

import UIKit


struct Note: Codable {
    let id: String
    let userId: String
    let text: String
    let v: Int
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId
        case text
        case v = "__v"
    }
}




class ViewController: UIViewController {
    
    let mainScreen = MainScreenView()
    
    var notesList = [Note]()
    var currentUser: User?
    
    
    override func loadView() {
        view = mainScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: handling if the Authentication state is changed (sign in, sign out, register)...
        
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            // Fetch notes if user is logged in
            fetchNotes(token: accessToken)
        }
        else {
            // Handle not logged in state
            // Update UI accordingly
            mainScreen.labelText.text = "Please sign in to see the notes!"
            mainScreen.floatingButtonAddNote.isEnabled = false
            mainScreen.floatingButtonAddNote.isHidden = true
            // Reset tableView...
            notesList.removeAll()
            mainScreen.tableViewNotes.reloadData()
            // Sign in bar button...
            setupRightBarButton(isLoggedin: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            title = "My Notes"
            
            setupRightBarButton(isLoggedin: true)
            
            NotificationCenter.default.addObserver(self, selector: #selector(profilePicTapped), name: NSNotification.Name("profilePicTapped"), object: nil)
            
            
            
            //MARK: patching table view delegate and data source...
            mainScreen.tableViewNotes.delegate = self
            mainScreen.tableViewNotes.dataSource = self
            
            //MARK: removing the separator line...
            mainScreen.tableViewNotes.separatorStyle = .none
            
            //MARK: Make the titles look large...
            navigationController?.navigationBar.prefersLargeTitles = true
            
            //MARK: Put the floating button above all the views...
            view.bringSubviewToFront(mainScreen.floatingButtonAddNote)
            
            //MARK: tapping the floating add note button...
            mainScreen.floatingButtonAddNote.addTarget(self, action: #selector(addNoteButtonTapped), for: .touchUpInside)
            
            if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
                // Fetch notes if user is logged in
                fetchNotes(token: accessToken)
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        Auth.auth().removeStateDidChangeListener(handleAuth!)
    }
    
    
    
    @objc func addNoteButtonTapped(){
        let addNoteController = AddNoteViewController()
        //        addNoteController.currentUser = self.currentUser
        navigationController?.pushViewController(addNoteController, animated: true)
    }
    
    @objc func profilePicTapped() {
        // Instantiate and present the new view controller
        let profileViewController = ProfileViewController() // Replace ProfileViewController with the actual name of your view controller
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func fetchNotes(token: String) {
        let apiConfigs = APIConfigs() // Create an instance of APIConfigs
        apiConfigs.getAllNotes(token: token) { [weak self] (notes: [Note]?, error: Error?) in
            guard let self = self else { return }
            if let notes = notes {
                self.notesList = notes
                DispatchQueue.main.async {
                    self.mainScreen.tableViewNotes.reloadData()
                    self.mainScreen.labelText.text = "Welcome \(self.currentUser?.name ?? "Anonymous")!"
                    self.mainScreen.floatingButtonAddNote.isEnabled = true
                    self.mainScreen.floatingButtonAddNote.isHidden = false
                    self.setupRightBarButton(isLoggedin: true)
                }
            } else if let error = error {
                print("Error fetching notes: \(error.localizedDescription)")
                // Handle error...
            }
        }
    }
    
}

