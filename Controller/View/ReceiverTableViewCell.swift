//
//  RecieverTableViewCell.swift
//  Chat Hub
//
//  Created by Apple on 25/02/2024.
//

import UIKit

class ReceiverTableViewCell: UITableViewCell {

    
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view.layer.cornerRadius=10;
        view.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
