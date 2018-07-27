//
//  RequestsTableViewCell.swift
//  Bombchat
//
//  Created by Mohaned Al-Feky on 7/27/18.
//  Copyright © 2018 mohaned. All rights reserved.
//

import UIKit

class RequestsTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
