//
//  BuildInvestmentPortfolioViewController.swift
//  LienFund
//
//  Created by Brando Flores on 12/25/21.
//

import UIKit

class BuildInvestmentPortfolioViewController: UIViewController {

    @IBOutlet weak var TotalInvestmentFrame: UIView!
    @IBOutlet weak var InvestmentObjectiveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        // Total investment frame
        TotalInvestmentFrame.layer.cornerRadius = 10
        TotalInvestmentFrame.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        TotalInvestmentFrame.clipsToBounds = true
        
        // Investment Objective Button
        InvestmentObjectiveButton.layer.cornerRadius = 10
        InvestmentObjectiveButton.clipsToBounds = true
    }

    @IBAction func InvestmentObjectiveButtonClicked(_ sender: UIButton) {
        print("It worked")
    }
}
