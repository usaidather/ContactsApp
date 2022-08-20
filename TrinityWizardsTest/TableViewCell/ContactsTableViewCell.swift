//
//  ContactsTableViewCell.swift
//  TrinityWizardsTest
//
//  Created by Usaid Ather on 20/08/2022.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactAvatar: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contactAvatar.layer.borderWidth = 1.0
        contactAvatar.layer.masksToBounds = false
        contactAvatar.layer.borderColor = UIColor.white.cgColor
        contactAvatar.layer.cornerRadius = contactAvatar.frame.size.width / 2
        contactAvatar.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
