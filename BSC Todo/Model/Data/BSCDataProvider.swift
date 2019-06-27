//
//  BSCDataProvider.swift
//  BSC Todo
//
//  Created by Lukas Sedlak on 22/06/2019.
//  Copyright © 2019 Lukas Sedlak. All rights reserved.
//

import Foundation
import UIKit
import os.log

class BSCDataProvider: DataProvider {
    
    private let dataURL = URL(string: "https://private-anon-5b814fe6c5-note10.apiary-mock.com/notes")!
    
    func allNotes(completion: @escaping ([Note], Error?) -> ()) {
        URLSession.shared.dataTask(with: dataURL) { data, response, error in
            guard let data = data, error == nil else {
                os_log("%s", log: OSLog.default, type: .debug, error?.localizedDescription ?? "Unknown Error")
                completion([], error)
                return
            }
            do {
                let notes = try JSONDecoder().decode([Note].self, from: data)
                completion(notes, error)
            } catch let error {
                os_log("%s", log: OSLog.default, type: .debug, error.localizedDescription)
            }
        }.resume()
    }
    
    func provideNote(with id: Int, completion: @escaping (Note?, Error?) -> ()) {
        let getNoteUrl = URL(string: "https://private-anon-5b814fe6c5-note10.apiary-mock.com/notes/\(id)")!
        let request = URLRequest(url: getNoteUrl)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                os_log("%s", log: OSLog.default, type: .debug, error?.localizedDescription ?? "Unknown Error")
                completion(nil, error)
                return
            }
            do {
                let note = try JSONDecoder().decode(Note.self, from: data)
                completion(note, error)
            } catch let error {
                os_log("%s", log: OSLog.default, type: .debug, error.localizedDescription)
            }
        }.resume()
    }
    
    func deleteNote(with id: Int, completion: @escaping (Error?) -> ()) {
        let deleteUrl = URL(string: "https://private-anon-5b814fe6c5-note10.apiary-mock.com/notes/\(id)")!
        
        var request = URLRequest(url: deleteUrl)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: dataURL) { data, response, error in
            if let error = error {
                os_log("%s", log: OSLog.default, type: .debug, error.localizedDescription)
                completion(error)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    func createNote(title: String, completion: @escaping (Note?, Error?) -> ()) {
        var request = URLRequest(url: dataURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = """
        "{\n  \"title\": \"\(title)\"\n}"
        """.data(using: .utf8)
        
        upladDataTask(request: request, completion: completion).resume()
    }
    
    func updateNote(id: Int, title: String, completion: @escaping (Note?, Error?) -> ()) {
        let updateUrl = URL(string: "https://private-anon-5b814fe6c5-note10.apiary-mock.com/notes/\(id)")!
        
        var request = URLRequest(url: updateUrl)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = """
            "{\n  \"title\": \"\(title)\"\n}"
            """.data(using: .utf8)
        
        upladDataTask(request: request, completion: completion).resume()
    }
    
    func upladDataTask(request: URLRequest, completion: @escaping (Note?, Error?) -> ()) -> URLSessionDataTask {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                os_log("%s", log: OSLog.default, type: .debug, error?.localizedDescription ?? "Unknown Error")
                completion(nil, error)
                return
            }
            do {
                let note = try JSONDecoder().decode(Note.self, from: data)
                completion(note, error)
            } catch let error {
                os_log("%s", log: OSLog.default, type: .debug, error.localizedDescription)
            }
        }
        return dataTask
    }
}
