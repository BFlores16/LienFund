//
//  LienListingsViewController.swift
//  LienFund
//
//  Created by Brando Flores on 12/18/21.
//

import UIKit

class LienListingsViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    final let LIENS_DATA_FILE = "liens_data"
    var taxLiens = [TaxLien]()
    var lienListingsCellsViewModels = [LienListingCellViewModel]()
    let lienListingReusableCellIdentifier = "TaxLienListingTableViewCell"
    
    @IBOutlet weak var taxLienSearchBar: UISearchBar!
    @IBOutlet weak var taxLienFilterButton: UIButton!
    @IBOutlet weak var taxLienListingsTableView: UITableView!
    @IBOutlet weak var taxLienListingsTableViewFrame: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        taxLienListingsTableView.delegate = self
        taxLienListingsTableView.dataSource = self
        taxLienListingsTableView.register(UINib(nibName: lienListingReusableCellIdentifier, bundle: nil), forCellReuseIdentifier: lienListingReusableCellIdentifier)
        
        
        parseTaxLienData()
        setupInitialUI()
    }
    
    func parseTaxLienData() {
        taxLiens = convertToLiensListings(liensData: readTxtFile(fileName: LIENS_DATA_FILE))
        lienListingsCellsViewModels = convertTaxLienToLienListingCellViewModels(taxLiens: taxLiens)
    }
    
    func setupInitialUI() {
        // Nav bar
        navigationController?.navigationBar.prefersLargeTitles = true
        taxLienSearchBar.searchTextField.backgroundColor = UIColor.white
        
        // Filter button
        let image = UIImage(named: "Filter2")// your image
        let targetSize = CGSize(width: 30, height: 30)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.lienListingsCellsViewModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let spacing: CGFloat = 10
        return spacing
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = self.taxLienListingsTableView.dequeueReusableCell(withIdentifier: lienListingReusableCellIdentifier, for: indexPath) as! TaxLienListingTableViewCell
        cell.selectionStyle = .none
        
        cell.LienNumberLabel.text = "# " + String(self.lienListingsCellsViewModels[indexPath.section].number)
        cell.LienLocationLabel.text = self.lienListingsCellsViewModels[indexPath.section].county + ", " + self.lienListingsCellsViewModels[indexPath.section].state
        cell.LienPriceLabel.text = String(self.lienListingsCellsViewModels[indexPath.section].price)
        cell.InterestRateLabel.text = String(self.lienListingsCellsViewModels[indexPath.section].rate)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LienDetailsViewController") as! LienDetailsViewController
        navigationController?.pushViewController(vc, animated: true)
        vc.taxLien = taxLiens[indexPath.section]
        taxLienListingsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func readTxtFile(fileName: String) -> [String] {
        var lines = [String]()

        if let dataURL = Bundle.main.url(forResource: fileName, withExtension: "txt") {
            if let data = try? String(contentsOf: dataURL) {
                lines = data.components(separatedBy: "\n")
            }
        }
        lines.remove(at: lines.count - 1)
        
        return lines
    }
    
    func convertToLiensListings(liensData: [String]) -> [TaxLien] {
        var liens = [TaxLien]()
        
        for lien in liensData {
            let lienElements = lien.split(separator: ",")

            let number = Int(lienElements[0]) ?? 0
            let county = String(lienElements[1])
            let state = String(lienElements[2])
            let price = Double(lienElements[3]) ?? 0.0
            let rate = Double(lienElements[4]) ?? 0.0
            liens.append(TaxLien(number: number, county: county, state: ShortStates.C[state] ?? "", price: price, rate: rate))
        }
        
        return liens
    }
    
    func convertTaxLienToLienListingCellViewModels(taxLiens: [TaxLien]) -> [LienListingCellViewModel] {
        var viewModels = [LienListingCellViewModel]()
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        for lien in taxLiens {
            viewModels.append(LienListingCellViewModel(number: lien.number, state: lien.state, county: lien.county, price: currencyFormatter.string(from: NSNumber(value: lien.price))!, rate: String(format: "%.1f%%", lien.rate)))
        }
        return viewModels
    }
}
