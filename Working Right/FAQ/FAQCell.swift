//
//  FAQCell.swift
//  Working Rights
//
//  Created by Qingzhou Wang on 22/09/2016.
//  Copyright © 2016 Qingzhou Wang. All rights reserved.
//

import UIKit

class FAQCell: UITableViewCell {

    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var bestAnswer: UILabel!
    @IBOutlet weak var like: UILabel!
    @IBOutlet weak var dislike: UILabel!
    @IBOutlet weak var answerCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
