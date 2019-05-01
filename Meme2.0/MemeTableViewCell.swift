//
//  MemeTableViewCell.swift
//  Meme2.0
//
//  Created by Abdullah alammar on 25/04/2019.
//  Copyright © 2019 Abdullah alammar. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var MemeImageView: UIImageView!
    
    @IBOutlet weak var topTextLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
