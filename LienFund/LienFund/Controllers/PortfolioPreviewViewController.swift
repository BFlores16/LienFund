//
//  PortfolioPreviewViewController.swift
//  LienFund
//
//  Created by Brando Flores on 1/12/22.
//

import UIKit

class PortfolioPreviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var myPortfolioTable: UITableView!
    var taxLiens = [TaxLien]()
    var lienListingsCellsViewModels = [LienListingCellViewModel]()
    @IBOutlet weak var confirmButtonFrame: UIView!
    @IBOutlet weak var summaryFrame: UIView!
    let lienListingReusableCellIdentifier = "TaxLienListingTableViewCell"
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var numberOfLiensLabel: UILabel!
    @IBOutlet weak var feesLabel: UILabel!
    
    // Database
    let portfolioDB = PortfolioTable()
    let purchasedDB = PurchasedTable()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Table view
        myPortfolioTable.delegate = self
        myPortfolioTable.dataSource = self
        myPortfolioTable.register(UINib(nibName: lienListingReusableCellIdentifier, bundle: nil), forCellReuseIdentifier: lienListingReusableCellIdentifier)
        
        parseTaxLienData()
        
        // Confirm button
        confirmButtonFrame.layer.cornerRadius = 10
        confirmButtonFrame.clipsToBounds = true
        
        // Portfolio Data
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        var totalPrice = 0.0
        for lien in taxLiens {
            totalPrice += lien.price
        }
        totalPriceLabel.text = currencyFormatter.string(from: NSNumber(value: totalPrice))!
        numberOfLiensLabel.text = String(taxLiens.count)
        feesLabel.text = currencyFormatter.string(from: NSNumber(value: totalPrice * 0.05))!
        
        // Summary Frame
        summaryFrame.layer.cornerRadius = 30
    }
    
    func parseTaxLienData() {
        taxLiens = self.portfolioDB.GetTaxLiens()
        lienListingsCellsViewModels = convertTaxLienToLienListingCellViewModels(taxLiens: taxLiens)
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell = self.myPortfolioTable.dequeueReusableCell(withIdentifier: lienListingReusableCellIdentifier, for: indexPath) as! TaxLienListingTableViewCell
        cell.selectionStyle = .none
        
        cell.LienNumberLabel.text = "# " + String(self.lienListingsCellsViewModels[indexPath.section].number)
        cell.LienLocationLabel.text = self.lienListingsCellsViewModels[indexPath.section].county + ", " + self.lienListingsCellsViewModels[indexPath.section].state
        cell.LienPriceLabel.text = String(self.lienListingsCellsViewModels[indexPath.section].price)
        cell.InterestRateLabel.text = String(self.lienListingsCellsViewModels[indexPath.section].rate)

        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LienDetailsViewController") as! LienDetailsViewController
//        navigationController?.pushViewController(vc, animated: true)
//        vc.taxLien = taxLiens[indexPath.section]
//        taxLienListingsTableView.deselectRow(at: indexPath, animated: true)
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
    
    @IBAction func confirmButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toCompleted", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toCompleted") {
            if let vc = segue.destination as? CompletedViewController {
                vc.message = "Success! Lienfund will review your request and follow up with further instructions."
            }
        }
    }
}
