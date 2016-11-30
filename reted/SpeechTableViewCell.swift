//
//  SpeechTableViewCell.swift
//  reted
//
//  Created by seojungwon on 2016. 12. 1..
//  Copyright © 2016년 seojungwon. All rights reserved.
//

import UIKit

class SpeechTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
