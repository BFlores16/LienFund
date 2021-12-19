//
//  LienListingsViewController.swift
//  LienFund
//
//  Created by Brando Flores on 12/18/21.
//

import UIKit

class LienListingsViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var taxLienSearchBar: UISearchBar!
    @IBOutlet weak var taxLienFilterButton: UIButton!
    
    @IBOutlet weak var taxLienListingsTableViewFrame: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupInitialUI()
    }
    
    func setupInitialUI() {
        // Tab bar
//        self.tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
//        self.tabBarController?.tabBar.layer.shadowRadius = 8
//        self.tabBarController?.tabBar.layer.shadowColor = UIColor.black.cgColor
//        self.tabBarController?.tabBar.layer.shadowOpacity = 0.3
        //self.tabBarController?.viewDidLayoutSubviews()
        
        
        // Nav bar
        navigationController?.navigationBar.prefersLargeTitles = true
        taxLienSearchBar.searchTextField.backgroundColor = UIColor.white
        
        // Filter button
        let image = UIImage(named: "Filter2")// your image
        let targetSize = CGSize(width: 40, height: 40)
        // Compute the scaling ratio for the width and height separately
        let widthScaleRatio = targetSize.width / image!.size.width
        let heightScaleRatio = targetSize.height / image!.size.height
        // To keep the aspect ratio, scale by the smaller scaling ratio
        let scaleFactor = min(widthScaleRatio, heightScaleRatio)
        // Multiply the original image’s dimensions by the scale factor
        // to determine the scaled image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: image!.size.width * scaleFactor,
            height: image!.size.height * scaleFactor
        )
        let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
        let scaledImage = renderer.image { _ in
            image!.draw(in: CGRect(origin: .zero, size: scaledImageSize))
        }
        taxLienFilterButton.imageView?.image = scaledImage
        
        // Search bar
        taxLienSearchBar.delegate = self
        
        // Table View
        taxLienListingsTableViewFrame.layer.cornerRadius = 30
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        taxLienSearchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
