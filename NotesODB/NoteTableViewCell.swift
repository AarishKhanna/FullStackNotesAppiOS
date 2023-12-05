//
//  NoteTableViewCell.swift
//  NotesODB
//
//  Created by Aarish Khanna on 2023-12-05
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    // Custom cell class to import the labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
