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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.layer.cornerRadius = 10
//        self.layer.masksToBounds = true
//
//        self.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
//        self.layer.borderWidth = 1
        
//        self.addShadow(shadowColor: .black, offSet: CGSize(width: 2.5, height: 2.5), opacity: 0.8, shadowRadius: 5.0, cornerRadius: 10, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
        addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addShadow() {
         self.layer.cornerRadius = 10
        let shadowPath2 = UIBezierPath(rect: self.contentView.layer.bounds)
         self.layer.masksToBounds = false
         self.layer.shadowColor = UIColor.black.cgColor
         self.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(3.0))
         self.layer.shadowOpacity = 0.5
         self.layer.shadowPath = shadowPath2.cgPath
    }
    
    func addShadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .white) {
        
        let shadowLayer = CAShapeLayer()
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
        shadowLayer.path = cgPath //2
        shadowLayer.fillColor = fillColor.cgColor //3
        shadowLayer.shadowColor = shadowColor.cgColor //4
        shadowLayer.shadowPath = cgPath
        shadowLayer.shadowOffset = offSet //5
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowRadius
        self.layer.addSublayer(shadowLayer)
    }
    
}
