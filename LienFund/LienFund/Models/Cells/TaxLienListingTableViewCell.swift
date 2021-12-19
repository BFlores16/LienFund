//
//  TaxLienListingTableViewCell.swift
//  LienFund
//
//  Created by Brando Flores on 12/18/21.
//

import UIKit

class TaxLienListingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var LienNumberLabel: UILabel!
    @IBOutlet weak var LienLocationLabel: UILabel!
    @IBOutlet weak var LienPriceLabel: UILabel!
    @IBOutlet weak var InterestRateLabel: UILabel!
    @IBOutlet weak var CellFrame: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func addShadow() {
        CellFrame.layer.cornerRadius = 10
        CellFrame.layer.shadowColor = UIColor.black.cgColor
        CellFrame.layer.shadowOpacity = 0.4
        CellFrame.layer.shadowRadius = 4
        CellFrame.layer.shadowOffset = CGSize.zero
    }
}
