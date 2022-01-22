//
//  StateTableViewCell.swift
//  LienFund
//
//  Created by Brando Flores on 1/18/22.
//

import UIKit

class StateTableViewCell: UITableViewCell {

    var isChecked: Bool = false
    @IBOutlet weak var stateName: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateCheckButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCheckButton() {
        if (isChecked) {
            checkButton.setImage(UIImage.init(systemName: "checkmark.square"), for: .normal)
        } else {
            checkButton.setImage(UIImage.init(systemName: "square"), for: .normal)
        }
    }

    @IBAction func checkButtonClicked(_ sender: UIButton) {
//        isChecked = !isChecked
//        updateCheckButton()
    }
}
