//
//  BuildInvestmentPortfolioViewController.swift
//  LienFund
//
//  Created by Brando Flores on 12/25/21.
//

import UIKit

class BuildInvestmentPortfolioViewController: UIViewController, InvestmentObjectiveDelegate {
    
    var investmentObjectiveOption = 2
    @IBOutlet weak var TotalInvestmentFrame: UIView!
    @IBOutlet weak var InvestmentObjectiveButton: UIButton!
    @IBOutlet weak var totalInvestmentTextField: UITextField!
    
    @IBOutlet weak var investmentObjectiveOptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        totalInvestmentTextField.addTarget(self, action: #selector(totalInvestmentTextFieldDidChange), for: .editingChanged)

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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InvestmentObjectiveOptionsViewController") as! InvestmentObjectiveOptionsViewController
        vc.selectedOption = investmentObjectiveOption
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        
        nav.modalPresentationStyle = .pageSheet
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        present(nav, animated: true, completion: nil)
    }

    @objc func totalInvestmentTextFieldDidChange(_ textField: UITextField) {

        if let amountString = totalInvestmentTextField.text?.currencyInputFormatting() {
            totalInvestmentTextField.text = amountString
        }
    }
    
    func investmentObjectiveSelected(option: Int) {
        switch (option) {
        case 0:
            investmentObjectiveOption = 0
            investmentObjectiveOptionLabel.text = "High-Growth"
            break
        case 1:
            investmentObjectiveOption = 1
            investmentObjectiveOptionLabel.text = "Moderate, Diverse"
            break
        case 2:
            investmentObjectiveOption = 2
            investmentObjectiveOptionLabel.text = "Conservative"
            break
        default:
            break
        }
    }
}

extension String {
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
    
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
    
        var amountWithPrefix = self
    
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
    
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
    
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return "$0.00"
        }
    
        return formatter.string(from: number)!
    }
}
