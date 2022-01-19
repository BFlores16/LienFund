//
//  InvestmentObjectiveOptionsViewController.swift
//  LienFund
//
//  Created by Brando Flores on 1/16/22.
//

import UIKit

protocol InvestmentObjectiveDelegate: AnyObject {
    func investmentObjectiveSelected(option: Int)
}

class InvestmentObjectiveOptionsViewController: UIViewController {
    
    weak var delegate: InvestmentObjectiveDelegate?
    var selectedOption: Int?
    @IBOutlet weak var highGrowthButton: UIButton!
    @IBOutlet weak var moderateButton: UIButton!
    @IBOutlet weak var conservativeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UpdateButton(optionIndex: selectedOption ?? 2)
        // Do any additional setup after loading the view.
    }
    
    func UpdateButton(optionIndex: Int) {
        highGrowthButton.setImage(UIImage.init(systemName: "circle"), for: .normal)
        moderateButton.setImage(UIImage.init(systemName: "circle"), for: .normal)
        conservativeButton.setImage(UIImage.init(systemName: "circle"), for: .normal)
        
        switch (optionIndex) {
        case 0:
            highGrowthButton.setImage(UIImage.init(systemName: "circle.inset.filled"), for: .normal)
            selectedOption = 0
            break
        case 1:
            moderateButton.setImage(UIImage.init(systemName: "circle.inset.filled"), for: .normal)
            selectedOption = 1
            break
        case 2:
            conservativeButton.setImage(UIImage.init(systemName: "circle.inset.filled"), for: .normal)
            selectedOption = 2
            break
        default:
            break
        }
    }
    
    @IBAction func HighGrowthButtonClicked(_ sender: UIButton) {
        UpdateButton(optionIndex: 0)
    }
    @IBAction func ModerateButtonClicked(_ sender: UIButton) {
        UpdateButton(optionIndex: 1)
    }
    @IBAction func ConservativeButtonClicked(_ sender: UIButton) {
        UpdateButton(optionIndex: 2)
    }
    
    @IBAction func CancelButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func ConfirmButtonClicked(_ sender: UIButton) {
        delegate?.investmentObjectiveSelected(option: selectedOption ?? 2)
        self.dismiss(animated: true, completion: nil)
    }
    
}
