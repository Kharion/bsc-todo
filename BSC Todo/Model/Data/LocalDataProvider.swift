//
//  LocalDataProvider.swift
//  BSC Todo
//
//  Created by Lukas Sedlak on 22/06/2019.
//  Copyright © 2019 Lukas Sedlak. All rights reserved.
//

import Foundation

class LocalDataProvider: DataProvider {
    
    var dataStore: [Int: Note] = [:]
    var uid = 0
    
    init() {
        dataStore[uid] = Note(id: 1, title: "Test note 1")
        uid += 1
        dataStore[uid] = Note(id: 2, title: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ")
        uid += 1
        dataStore[uid] = Note(id: 3, title: "Test note 4, bla bla bla")
    }
    
    func allNotes(completion: @escaping ([Note], Error?) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            if let weakSelf = self {
                sleep(1)
                completion(Array(weakSelf.dataStore.values), nil)
            }
        }
    }
    
    func provideNote(with id: Int, completion: @escaping (Note?, Error?) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            if let weakSelf = self {
                sleep(1)
                completion(weakSelf.dataStore[id], nil)
            }
        }
    }
    
    func deleteNote(with id: Int, completion: @escaping(Error?) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            if let weakSelf = self {
                weakSelf.dataStore[id] = nil
                sleep(1)
                completion(nil)
            }
        }
    }
    
    func createNote(title: String, completion: @escaping (Note?, Error?) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            if let weakSelf = self {
                weakSelf.uid += 1
                let note = Note(id: weakSelf.uid, title: title);
                weakSelf.dataStore[weakSelf.uid] = note
                sleep(1)
                completion(note, nil)
            }
        }
    }
    
    func updateNote(id: Int, title: String, completion: @escaping (Note?, Error?) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            if let weakSelf = self {
                let note = Note(id: id, title: title);
                weakSelf.dataStore[id] = note
                sleep(1)
                completion(note, nil)
            }
        }
    }
}
