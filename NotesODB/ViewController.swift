//
//  ViewController.swift
//  NotesODB
//
//  Created by Aarish Khanna on 2023-12-05.
//

import UIKit

// Custom protocol that parses the JSON and updated the arrray
protocol DataDelegate {
    func updateArray(newArray: String)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    // Array of notes objects from the database
    var notesArray = [Notes]()
    
    // Need to send some data to the next viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // instantiate the AddViewController class
        let vc = segue.destination as! AddNoteViewController
        
        // If we are updating a note, tell the addnotecontroller to update, and give position of item to update
        if segue.identifier == "updateNoteSegue" {
            // Give the reverse index (0 in the table view is the oldest item in database instead of newest)
            vc.update = true
            vc.isValidDelete = true
            vc.note = notesArray[ (notesArray.count-1) - ((tableView.indexPathForSelectedRow)?.row ?? 0)]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // the delegate is the class that handles the API requests
        APIMethods.functions.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Update and load the new data into the tableview
        APIMethods.functions.fetchNotes()
        self.tableView.reloadData()
    }
    
    // Everytime the list of notes is shown, update the array of notes and the tableview
    override func viewWillAppear(_ animated: Bool) {
        APIMethods.functions.fetchNotes()
        self.tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate {
    
    // Don't need a didselectrow function because it uses a segue through stroyboards instead
    // Return a custom cell height of 85
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
}

extension ViewController: UITableViewDataSource {
    
    // Render as many rows as items
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            let arrayIndexReverse = (notesArray.count-1) - indexPath.row
            APIMethods.functions.deleteNote(id: notesArray[arrayIndexReverse]._id)
            APIMethods.functions.fetchNotes()
            tableView.deleteRows(at: [indexPath], with: .bottom)
            
        }
    }
    
    // Customize each cell with date, note and title from the database item
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Want to display the notes from newest to oldest so show the array in reverse
        let arrayIndexReverse = (notesArray.count-1) - indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototype", for: indexPath) as! NoteTableViewCell
        cell.timeLabel.text = notesArray[arrayIndexReverse].date
        cell.titleLabel.text = notesArray[arrayIndexReverse].title
        cell.noteLabel.text = notesArray[arrayIndexReverse].note
        
        return cell
    }
}

extension ViewController: DataDelegate {
    
    // Get data from the API call and parse it
    func updateArray(newArray: String) {
        do{
            notesArray = try JSONDecoder().decode([Notes].self,from: newArray.data(using: .utf8)!)
        }catch let jsonErr {
            print(jsonErr)
        }
        self.tableView.reloadData()
    }
    
}
