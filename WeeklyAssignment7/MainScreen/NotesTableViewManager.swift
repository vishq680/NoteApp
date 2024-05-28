//
//  NotesTableViewManager.swift
//  WeeklyAssignment7
//
//  Created by Vishaq Jayakumar on 3/17/24.
//

import Foundation
import UIKit
import Alamofire

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewNotesID, for: indexPath) as! NotesTableViewCell
        let note = notesList[indexPath.row]
        cell.labelNote.text = note.text
        cell.deleteButton.isHidden = false // Show delete button
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Return the desired row height to accommodate the delete button
        return 80 // Adjust this value as needed
    }
    
    func handleDeleteAction(for note: Note) {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            print("Access token not found in UserDefaults")
            return
        }
        
        let headers: HTTPHeaders = [
            "x-access-token": accessToken
        ]
        
        let parameters: [String: Any] = [
            "id": note.id
        ]
        
        AF.request("\(APIConfigs.baseURL)auth/delete", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            switch response.result {
            case .success:
                if let index = self.notesList.firstIndex(where: { $0.id == note.id }) {
                    self.notesList.remove(at: index)
                }
                // Reload the table view
                self.mainScreen.tableViewNotes.reloadData()
            case .failure(let error):
                print("Failed to delete note:", error)
            }
        }
        
        
        // For now, let's print a message to simulate the delete action
        print("Delete action for note: \(note.id)")
    }
    
    
}
