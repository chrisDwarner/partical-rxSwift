//
//  BoxDocTableViewCell.swift
//  particalIoTest
//
//  Created by chris warner on 4/29/18.
//  Copyright © 2018 chris warner. All rights reserved.
//

import UIKit

class BoxDocTableViewCell: UITableViewCell {

    @IBOutlet weak var key: UILabel!
    @IBOutlet weak var device_id: UILabel!

    func configureWithBox( boxDocument: BoxDocument) {
        key.text = boxDocument.key
        device_id.text = boxDocument.device_id
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
