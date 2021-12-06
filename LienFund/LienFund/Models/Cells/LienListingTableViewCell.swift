//
//  LienListingTableViewCell.swift
//  LienFund
//
//  Created by Brando Flores on 11/19/21.
//

import UIKit

class LienListingTableViewCell: UITableViewCell {
    @IBOutlet weak var LienNumberLabel: UILabel!
    @IBOutlet weak var LienLocationLabel: UILabel!
    @IBOutlet weak var InterestRateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let chevronImage = resizeImage(image: UIImage(named: "Chevron")!, targetSize: CGSize(width: 10.0, height: 10.0))
        let chevronImageView = UIImageView(image: chevronImage)
        accessoryView = chevronImageView
        
        InterestRateLabel.layer.cornerRadius = 10
        InterestRateLabel.layer.masksToBounds = true
        
        
//        DollarInterestStackView.layer.cornerRadius = 10
//        DollarInterestStackView.layer.masksToBounds = true
//        InterestRateLabel.layer.cornerRadius = 10
//        InterestRateLabel.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

}
