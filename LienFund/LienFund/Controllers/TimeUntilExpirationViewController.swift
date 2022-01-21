//
//  InvestmentObjectiveOptionsViewController.swift
//  LienFund
//
//  Created by Brando Flores on 1/16/22.
//

import UIKit

protocol TimeUntilExpirationDelegate: AnyObject {
    func TimeUntilExpirationSelected(option: Int)
}

class TimeUntilExpirationViewController: UIViewController {
    weak var delegate: TimeUntilExpirationDelegate?
    var selectedOption: Int?
    
    @IBOutlet weak var noPreferenceButton: UIButton!
    @IBOutlet weak var longButton: UIButton!
    @IBOutlet weak var soonButton: UIButton!
    @IBOutlet weak var verySoonButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UpdateButton(optionIndex: selectedOption ?? 3)
        // Do any additional setup after loading the view.
    }
    
    func UpdateButton(optionIndex: Int) {
        noPreferenceButton.setImage(UIImage.init(systemName: "circle"), for: .normal)
        longButton.setImage(UIImage.init(systemName: "circle"), for: .normal)
        soonButton.setImage(UIImage.init(systemName: "circle"), for: .normal)
        verySoonButton.setImage(UIImage.init(systemName: "circle"), for: .normal)
        
        switch (optionIndex) {
        case 0:
            noPreferenceButton.setImage(UIImage.init(systemName: "circle.inset.filled"), for: .normal)
            selectedOption = 0
            break
        case 1:
            longButton.setImage(UIImage.init(systemName: "circle.inset.filled"), for: .normal)
            selectedOption = 1
            break
        case 2:
            soonButton.setImage(UIImage.init(systemName: "circle.inset.filled"), for: .normal)
            selectedOption = 2
            break
        case 3:
            verySoonButton.setImage(UIImage.init(systemName: "circle.inset.filled"), for: .normal)
            selectedOption = 3
            break
        default:
            break
        }
    }
    
    @IBAction func noPreferenceButtonClicked(_ sender: UIButton) {
        UpdateButton(optionIndex: 0)
    }
    @IBAction func longButtonClicked(_ sender: UIButton) {
        UpdateButton(optionIndex: 1)
    }
    @IBAction func soonButtonClicked(_ sender: UIButton) {
        UpdateButton(optionIndex: 2)
    }
    @IBAction func verySoonButtonClicked(_ sender: UIButton) {
        UpdateButton(optionIndex: 3)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmButtonClicked(_ sender: UIButton) {
        delegate?.TimeUntilExpirationSelected(option: selectedOption ?? 3)
        self.dismiss(animated: true, completion: nil)
    }
    
}
