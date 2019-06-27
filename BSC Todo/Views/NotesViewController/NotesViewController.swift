//
//  ViewController.swift
//  BSC Todo
//
//  Created by Lukas Sedlak on 19/06/2019.
//  Copyright © 2019 Lukas Sedlak. All rights reserved.
//

import UIKit
import SVProgressHUD

class NotesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewNoteButton: UIButton!
    @IBOutlet weak var notesNavigationItem: UINavigationItem!
    
    private var tableData = [Note]()
    private let dataProvider: DataProvider = BSCDataProvider()
    private var newNote: Note?
    private let refreshControl = UIRefreshControl()
    
    func getDataProvider() -> DataProvider {
        return dataProvider
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesNavigationItem.rightBarButtonItem = editButtonItem
        initTableView()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let note = newNote {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableData[selectedIndexPath.row] = note
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: tableData.count, section: 0)
                tableData.append(note)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    private func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshNoteData), for: .valueChanged)
    }
    
    @objc private func refreshNoteData(_ sender: Any) {
        dataProvider.allNotes(completion: { [weak self] tableData, error in
            if let weakSelf = self {
                guard error == nil else {
                    DispatchQueue.main.async {
                        weakSelf.showAlertController(title: "Request Error", error: error)
                        weakSelf.refreshControl.endRefreshing()
                    }
                    return
                }
                
                weakSelf.tableData = tableData
                DispatchQueue.main.async {
                    weakSelf.tableView.reloadData()
                    weakSelf.refreshControl.endRefreshing()
                }
            }
        })
    }
    
    private func loadData() {
        SVProgressHUD.show(withStatus: "Loading data...")
        dataProvider.allNotes(completion: { [weak self] tableData, error in
            if let weakSelf = self {
                guard error == nil else {
                    DispatchQueue.main.async {
                        weakSelf.showAlertController(title: "Request Error", error: error)
                        SVProgressHUD.dismiss()
                    }
                    return
                }
                
                weakSelf.tableData = tableData
                DispatchQueue.main.async {
                    weakSelf.tableView.reloadData()
                }
            }
            SVProgressHUD.dismiss()
        })
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(!isEditing, animated: true)
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let editNoteViewController = segue.destination as? EditNoteViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        switch(segue.identifier ?? "") {
        case "AddNewNote":
            editNoteViewController.addNewNote(notesViewController: self)
        case"ShowNote":
            guard let selectedNoteCell = sender as? NotesTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "Unkown Identifier")")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedNoteCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedNote = tableData[indexPath.row]
            editNoteViewController.showDetail(note: selectedNote, notesViewController: self)
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "Unkown Identifier")")
        }
    }
    
    // MARK: - Actions
    
    func onNoteUpdate (note: Note) {
        newNote = note
    }
}

// MARK - Table View
extension NotesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell") else {
            fatalError("Unable to dequeue cell with identifier 'noteCell'")
        }
        
        guard let noteCell = cell as? NotesTableViewCell else {
            fatalError("Unable to cast cell to NotesTableViewCell")
        }
        
        noteCell.setup(note: tableData[indexPath.row])
        return noteCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            SVProgressHUD.show(withStatus: "Deleting data...")
            dataProvider.deleteNote(with: tableData[indexPath.row].id, completion: { [weak self] error in
                if let weakSelf = self {
                    guard error == nil else {
                        weakSelf.showAlertController(title: "Request Error", error: error)
                        SVProgressHUD.dismiss()
                        return
                    }
                    
                    weakSelf.tableData.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        weakSelf.tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
                SVProgressHUD.dismiss()
            })
        }
    }
}

