//
//  CompletedViewController.swift
//  LienFund
//
//  Created by Brando Flores on 1/25/22.
//

import UIKit

class CompletedViewController: UIViewController {
    
    @IBOutlet weak var buttonFrame: UIView!
    var message: String = ""
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonFrame.layer.cornerRadius = 10
        messageLabel.text = message
    }
    
    @IBAction func closeButtonClicked(_ sender: UIButton) {
//        dismiss(animated: true, completion: nil)
//        dismiss(animated: true, completion: nil)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
}
