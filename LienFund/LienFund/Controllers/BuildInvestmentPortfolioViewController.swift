//
//  BuildInvestmentPortfolioViewController.swift
//  LienFund
//
//  Created by Brando Flores on 12/25/21.
//

import UIKit

class BuildInvestmentPortfolioViewController: UIViewController {

    @IBOutlet weak var TotalInvestmentFrame: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        // Total investment frame
        TotalInvestmentFrame.layer.cornerRadius = 10
        TotalInvestmentFrame.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        TotalInvestmentFrame.clipsToBounds = true
    }
}
