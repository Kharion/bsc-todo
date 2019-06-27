//
//  NotesTableViewCell.swift
//  BSC Todo
//
//  Created by Lukas Sedlak on 21/06/2019.
//  Copyright © 2019 Lukas Sedlak. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    @IBOutlet weak var noteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(note: Note) {
        noteLabel.text = note.title
    }
}
