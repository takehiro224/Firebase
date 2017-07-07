//
//  ListTableViewCell.swift
//  FirebaseSample
//
//  Created by tkwatanabe on 2017/07/07.
//  Copyright © 2017年 tkwatanabe. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
