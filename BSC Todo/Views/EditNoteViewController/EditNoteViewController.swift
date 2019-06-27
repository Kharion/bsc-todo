//
//  EditNoteViewController.swift
//  BSC Todo
//
//  Created by Lukas Sedlak on 21/06/2019.
//  Copyright © 2019 Lukas Sedlak. All rights reserved.
//

import UIKit
import SVProgressHUD

class EditNoteViewController: UIViewController {

    enum EditAction {
        case newNote
        case updateNote
    }
    
    @IBOutlet weak var noteText: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    private var note: Note?
    private var dataProvider: DataProvider?
    private var notesViewController: NotesViewController?
    
    private var editAction: EditAction = .newNote
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let note = note {
            noteText.text = note.title
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let note = note, let notesViewController = notesViewController {
            notesViewController.onNoteUpdate(note: note)
        }
    }

    // MARK: - Note Modification
    func addNewNote(notesViewController: NotesViewController) {
        self.notesViewController = notesViewController
        self.dataProvider = notesViewController.getDataProvider()
        
        editAction = .newNote
    }
    
    func showDetail(note: Note, notesViewController: NotesViewController) {
        self.note = note
        self.notesViewController = notesViewController
        self.dataProvider = notesViewController.getDataProvider()
        
        editAction = .updateNote
    }
    
    @IBAction func saveNote(_ sender: UIBarButtonItem) {
        guard let noteText = noteText.text, noteText != "" else {
            return
        }
        
        if (editAction == .newNote) {
            editAction = .updateNote
            
            SVProgressHUD.show(withStatus: "Saving...")
            dataProvider?.createNote(title: noteText, completion: { [weak self] note, error in
                if let weakSelf = self {
                    guard let note = note, error == nil else {
                        DispatchQueue.main.async {
                            weakSelf.showAlertController(title: "Request Error", error: error)
                            SVProgressHUD.dismiss()
                        }
                        return
                    }
                    weakSelf.note = note
                }
                SVProgressHUD.dismiss()
            })
        } else if (editAction == .updateNote) {
            if let note = note {
                SVProgressHUD.show(withStatus: "Saving...")
                dataProvider?.updateNote(id: note.id, title: noteText, completion: { [weak self] note, error in
                    if let weakSelf = self {
                        guard let note = note, error == nil else {
                            DispatchQueue.main.async {
                                weakSelf.showAlertController(title: "Request Error", error: error)
                                SVProgressHUD.dismiss()
                            }
                            return
                        }
                        weakSelf.note = note
                    }
                    SVProgressHUD.dismiss()
                })
            }
        }
    }
}
