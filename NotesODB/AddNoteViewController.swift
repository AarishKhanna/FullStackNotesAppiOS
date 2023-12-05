//
//  AddNoteViewController.swift
//  NotesODB
//
//  Created by Aarish Khanna on 2023-12-05.
//

import UIKit
import SwiftyJSON

class AddNoteViewController: UIViewController {
    
    // update tells save button to update, save tells button to add, and indexOfUpdate tells what to update in the database
    var isValidDelete = false
    var update = false
    var note: Notes!
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var noteField: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // Add borders to the title and note textfields (cant do in stroyboard)
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.layer.borderWidth = 1.2
        noteField.layer.borderWidth = 1.2
        titleField.layer.cornerRadius = 3.0
        noteField.layer.cornerRadius = 3.0
        titleField.layer.borderColor = UIColor.lightGray.cgColor
        noteField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    // If we are updating a note, we want the fields to already have the current values in them
    override func viewWillAppear(_ animated: Bool) {
        if update == true {
            // set the fields to the value of the note we are updating and change top title to edit instead of new note
            noteField.text = note.note
            titleField.text = note.title
            self.title = "Edit"
        }
    }
    
    @IBAction func deleteClicked(_ sender: Any) {
        if isValidDelete == true {
            // Pass the note id and return back to the main view
            APIMethods.functions.deleteNote(id: note._id)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // The save button. By deafult it adds.
    @IBAction func saveClick(_ sender: Any) {
        // Get the current date and turn it into a string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: Date())
        
        // If there is a valid note, either add or update
        if noteField.text! != "" && titleField.text! != "" {
            if update == true {
                
                APIMethods.functions.updateNote(id: note._id, title: titleField.text!, note: noteField.text!, date: date)
                
            } else  {
                
                APIMethods.functions.addNote(title: titleField.text!, note: noteField.text!, date: date)
                
            }

            // Return back to main screen after click
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}
