//
//  ApplianceTableViewCell.swift
//  Electricator
//
//  Created by Arif Rahman on 08/04/21.
//

import UIKit

class ApplianceTableViewCell: UITableViewCell {

    @IBOutlet weak var imageItemAppliance: UIImageView!
    @IBOutlet weak var textNameAppliance: UILabel!
    @IBOutlet weak var textQuantityAppliance: UILabel!
    @IBOutlet weak var lockHourViewAppliance: UIStackView!
    @IBOutlet weak var lockIcon: UIImageView!
    @IBOutlet weak var textFinalHourAppliance: UILabel!
    @IBOutlet weak var unlockHourViewAppliance: UIStackView!
    @IBOutlet weak var textHourAppliance: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
