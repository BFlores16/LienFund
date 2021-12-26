//
//  HelpViewController.swift
//  LienFund
//
//  Created by Brando Flores on 12/26/21.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var helpFrame: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        helpFrame.layer.cornerRadius = 30
    }
}
