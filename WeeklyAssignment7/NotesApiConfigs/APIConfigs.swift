//
//  APIConfigs.swift
//  WeeklyAssignment7
//
//  Created by Vishaq Jayakumar on 3/17/24.
//

import Foundation
import Alamofire

struct NotesResponse: Decodable {
    let notes: [Note]
    // Add other properties if necessary
}

struct NoteResponse: Codable {
    let notes: [Note]
}

class APIConfigs{
    //MARK: API base URL...
    static let baseURL = "http://apis.sakibnm.space:3000/api/"
    
    func getAllNotes(token: String, completion: @escaping ([Note]?, Error?) -> Void) {
        let headers: HTTPHeaders = [
            "x-access-token": token
        ]
        
        if let url = URL(string: APIConfigs.baseURL + "note/getall") {
            AF.request(url, headers: headers).responseData { (response: AFDataResponse<Data>) in
                switch response.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let notesResponse = try decoder.decode(NoteResponse.self, from: data)
//                        print("Parsed notes response:", notesResponse)
                        completion(notesResponse.notes, nil) // Pass the array of Note objects
                    } catch {
                        print("Error decoding JSON:", error)
                        completion(nil, error)
                    }
                case .failure(let error):
                    print("Networking error:", error)
                    completion(nil, error)
                }
            }
        } else {
            // Handle invalid URL
            print("Invalid URL")
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(nil, error)
        }
    }
    
    
    func addNewNote(token: String, text: String, completion: @escaping (Notes?, Error?) -> Void) {
        let headers: HTTPHeaders = [
            "x-access-token": token
        ]
        
        let parameters: [String: Any] = [
            "text": text
        ]
        
        AF.request("\(APIConfigs.baseURL)auth/post", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let note = try JSONDecoder().decode(Notes.self, from: data)
                    completion(note, nil)
                } catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func deleteNote(token: String, id: String, completion: @escaping (Error?) -> Void) {
        let headers: HTTPHeaders = [
            "x-access-token": token
        ]
        
        let parameters: [String: Any] = [
            "id": id
        ]
        
        AF.request("\(APIConfigs.baseURL)auth/delete", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            switch response.result {
            case .success:
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}
