//
//  CustomCell.swift
//  MusicTermApp
//
//  Created by Ui-Okuyama on 2021/09/06.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var correctOrFalseImage: UIImageView!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
