//
//  LienListingsViewController.swift
//  LienFund
//
//  Created by Brando Flores on 12/18/21.
//

import UIKit
import SQLite

class LienListingsViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    final let LIENS_DATA_FILE = "liens_data"
    var taxLiens = [TaxLien]()
    var lienListingsCellsViewModels = [LienListingCellViewModel]()
    let lienListingReusableCellIdentifier = "TaxLienListingTableViewCell"
    let NC = NotificationCenter.default
    
    // Database
    let lienListingsDB = ListingsTable()
    
    // Filter Data
    var filteredLiens: [LienListingCellViewModel]!
    
    @IBOutlet weak var taxLienSearchBar: UISearchBar!
    @IBOutlet weak var taxLienFilterButton: UIButton!
    @IBOutlet weak var taxLienListingsTableView: UITableView!
    @IBOutlet weak var taxLienListingsTableViewFrame: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NC.addObserver(self, selector: #selector(portfolioChanged), name: Notification.Name(Strings.NCPortfolioChanged), object: nil)
        NC.addObserver(self, selector: #selector(portfolioPurchaseCompleted), name: Notification.Name(Strings.NCPortfolioPurchaseCompleted), object: nil)
        
        taxLienListingsTableView.delegate = self
        taxLienListingsTableView.dataSource = self
        taxLienListingsTableView.register(UINib(nibName: lienListingReusableCellIdentifier, bundle: nil), forCellReuseIdentifier: lienListingReusableCellIdentifier)
        
        parseTaxLienData()
        filteredLiens = lienListingsCellsViewModels
        setupInitialUI()
    }
    
    func parseTaxLienData() {
        taxLiens = lienListingsDB.GetTaxLiens()
        lienListingsCellsViewModels = convertTaxLienToLienListingCellViewModels(taxLiens: taxLiens)
//        taxLiens = convertToLiensListings(liensData: readTxtFile(fileName: LIENS_DATA_FILE))
//        lienListingsCellsViewModels = convertTaxLienToLienListingCellViewModels(taxLiens: taxLiens)
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredLiens = lienListingsCellsViewModels
            taxLienListingsTableView.reloadData()
            return
        }
        let lienNumbers =  lienListingsCellsViewModels.filter( {String($0.number).contains(searchText)})

        let addresses =  lienListingsCellsViewModels.filter( {(String($0.address)).uppercased().contains(searchText.uppercased())})
        let prices =  lienListingsCellsViewModels.filter( {String($0.price).contains(searchText)})
        let counties =  lienListingsCellsViewModels.filter( {String($0.county.uppercased()).contains(searchText.uppercased())})
        let states =  lienListingsCellsViewModels.filter( {String($0.state.uppercased()).contains(searchText.uppercased())})
        let cities =  lienListingsCellsViewModels.filter( {String($0.city.uppercased()).contains(searchText.uppercased())})
        let zips =  lienListingsCellsViewModels.filter( {String($0.zipcode.uppercased()).contains(searchText.uppercased())})
        
        let items = lienNumbers + addresses + prices + counties + states + cities + zips
        
        if !items.isEmpty {
            filteredLiens.removeAll()
            filteredLiens.append(contentsOf: items)
            taxLienListingsTableView.reloadData()
        } else {
            filteredLiens.removeAll()
            taxLienListingsTableView.reloadData()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.filteredLiens.count
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
        
        cell.LienNumberLabel.text = "# " + String(self.filteredLiens[indexPath.section].number)
        cell.LienLocationLabel.text = self.filteredLiens[indexPath.section].county + ", " + self.filteredLiens[indexPath.section].state
        cell.LienPriceLabel.text = String(self.filteredLiens[indexPath.section].price)
        cell.InterestRateLabel.text = String(self.filteredLiens[indexPath.section].rate)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LienDetailsViewController") as! LienDetailsViewController
        navigationController?.pushViewController(vc, animated: true)
        let taxLien = filteredLiens[indexPath.section]
        vc.taxLien = TaxLien(number: taxLien.number, county: taxLien.county, state: taxLien.state, price: Double(taxLien.price.filter("0123456789.".contains)) ?? 0.0, rate: Double(taxLien.rate.filter("0123456789.".contains)) ?? 0.0, address: taxLien.address, city: taxLien.city, zipcode: taxLien.zipcode)
        taxLienListingsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func portfolioChanged() {
        parseTaxLienData()
        taxLienListingsTableView.reloadData()
    }
    
    @objc func portfolioPurchaseCompleted() {
        self.navigationController?.popToRootViewController(animated: false)
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
            let address = String(lienElements[5])
            let city = String(lienElements[6])
            let zipcode = String(lienElements[7])
            liens.append(TaxLien(number: number, county: county, state: ShortStates.C[state] ?? "", price: price, rate: rate, address: address, city: city, zipcode: zipcode))
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
            viewModels.append(LienListingCellViewModel(number: lien.number, state: lien.state, county: lien.county, price: currencyFormatter.string(from: NSNumber(value: lien.price))!, rate: String(format: "%.1f%%", lien.rate), address: lien.address, city: lien.city, zipcode: lien.zipcode))
        }
        
        return viewModels
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
