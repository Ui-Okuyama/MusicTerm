//
//  RankingTableViewCell.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/09/08.
//

import UIKit

class RankingTableViewCell: UITableViewCell {

    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
