//
//  DataProvider.swift
//  BSC Todo
//
//  Created by Lukas Sedlak on 22/06/2019.
//  Copyright © 2019 Lukas Sedlak. All rights reserved.
//

import Foundation

protocol DataProvider {
    
    func allNotes(completion: @escaping ([Note], Error?) -> ())
    
    func provideNote(with id: Int, completion: @escaping (Note?, Error?) -> ())
    
    func deleteNote(with id: Int, completion: @escaping (Error?) -> ())
    
    func createNote(title: String, completion: @escaping (Note?, Error?) -> ())
    
    func updateNote(id: Int, title: String, completion: @escaping (Note?, Error?) -> ())
}
