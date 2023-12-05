//
//  CoreDataFunctions.swift
//  NotesODB
//
//  Created by Aarish Khanna on 2023-12-05.
//

import Foundation
import CoreData
import Alamofire

// The data structure we will parse the data into
struct Notes: Decodable {
    var title: String
    var date: String
    var _id: String
    var note: String

    enum CodingKeys: String, CodingKey {
        case title
        case date
        case _id
        case note
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Use decodeIfPresent to handle optional keys
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        date = try container.decodeIfPresent(String.self, forKey: .date) ?? ""
        _id = try container.decode(String.self, forKey: ._id)
        note = try container.decodeIfPresent(String.self, forKey: .note) ?? ""
    }
}

class APIMethods{

    var delegate: DataDelegate?
    static let functions = APIMethods()
    
    func fetchNotes() {
            AF.request("http://192.168.1.4:8081/fetch").response { response in
        
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            
                // Once the data is recieved pass it using the delegat protocol
                self.delegate?.updateArray(newArray: utf8Text)
                
            }
        }
    }
    
    func addNote(title: String, note: String, date: String) {
        AF.request("http://192.168.1.4:8081/form", method: .post,  encoding: URLEncoding.httpBody, headers: ["title": title, "note": note, "date": date ]).responseJSON { (response) in
        }
    }
    
    func deleteNote(id: String) {
        AF.request("http://192.168.1.4:8081/delete", method: .post,  encoding: URLEncoding.httpBody, headers: ["id": id]).responseJSON { (response) in
        }
    }
    
    func updateNote(id: String, title: String, note: String, date: String) {
        AF.request("http://192.168.1.4:80811/update", method: .post,  encoding: URLEncoding.httpBody, headers: ["id": id, "title": title, "note": note, "date": date ]).responseJSON { (response) in
        }
    }
    
}

