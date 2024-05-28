//
//  AddNoteViewController.swift
//  WeeklyAssignment7
//
//  Created by Vishaq Jayakumar on 3/17/24.
//
import UIKit
import Alamofire

class AddNoteViewController: UIViewController {
    
    let addNoteScreen = AddNoteView()
    
    override func loadView() {
        view = addNoteScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Add a New Note"
        
        addNoteScreen.buttonAdd.addTarget(self, action: #selector(onAddButtonTapped), for: .touchUpInside)
    }
    
    //MARK: on add button tapped
    @objc func onAddButtonTapped() {
        guard let noteText = addNoteScreen.textFieldNote.text, !noteText.isEmpty else {
            // Show an alert if the note text is empty
            showAlert(message: "Please enter a note.")
            return
        }
        
        let newNote = Notes(note: noteText)
        addANewNote(note: newNote)
    }
    
    func addANewNote(note: Notes) {
        // Check if the access token is available
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            print("Access token not found in UserDefaults")
            return
        }
        
        // Construct the request URL
        guard let url = URL(string: APIConfigs.baseURL + "note/post") else {
            print("Invalid URL")
            return
        }
        
        // Define headers
        let headers: HTTPHeaders = ["x-access-token": accessToken]
        
        // Make the POST request
        AF.request(url, method: .post, parameters: ["text": note.note], headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    guard let jsonDict = data as? [String: Any] else {
                        print("Invalid JSON format in response")
                        return
                    }
                    if let posted = jsonDict["posted"] as? Bool, posted {
                        print("Note added successfully:", jsonDict)
                        // Show success message or navigate back
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        print("Failed to add note:", jsonDict)
                        // Show error message to the user
                        self.showAlert(message: "Failed to add note.")
                    }
                case .failure(let error):
                    print("Failed to add note:", error)
                    // Show error message to the user
                    self.showAlert(message: "Failed to add note. Please try again later.")
                }
            }
    }
    
    // Helper method to show an alert with a given message
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
