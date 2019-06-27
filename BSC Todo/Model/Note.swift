//
//  Note.swift
//  BSC Todo
//
//  Created by Lukas Sedlak on 22/06/2019.
//  Copyright © 2019 Lukas Sedlak. All rights reserved.
//

import Foundation

class Note: Codable {
    let id: Int
    let title: String
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
}
