//
//  AccountViewController.swift
//  LienFund
//
//  Created by Brando Flores on 12/26/21.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var accountHeaderFrame: UIView!
    @IBOutlet weak var accountProfilePhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
                // Account Header Frame
        accountHeaderFrame.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        accountHeaderFrame.layer.cornerRadius = 20
        
        // Profile Photo
        accountProfilePhoto.layer.cornerRadius = 30
    }
}
