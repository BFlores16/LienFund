//
//  BuildInvestmentPortfolioPreviewViewController.swift
//  LienFund
//
//  Created by Brando Flores on 1/23/22.
//

import UIKit

class BuildInvestmentPortfolioPreviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var investmentAmount = 0.0
    var investmentObjectiveOption = 2
    var timeUntilExpirationOption = 3
    var taxLiens = [TaxLien]()
    var lienListingsCellsViewModels = [LienListingCellViewModel]()

    @IBOutlet weak var buildPortfolioTableView: UITableView!
    @IBOutlet weak var confirmButtonFrame: UIView!
    @IBOutlet weak var summaryFrame: UIView!
    let lienListingReusableCellIdentifier = "TaxLienListingTableViewCell"
    @IBOutlet weak var numberOfLiensLabel: UILabel!
    @IBOutlet weak var annualReturnPercentLabel: UILabel!
    @IBOutlet weak var annualReturnDollarLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Table view
        buildPortfolioTableView.delegate = self
        buildPortfolioTableView.dataSource = self
        buildPortfolioTableView.register(UINib(nibName: lienListingReusableCellIdentifier, bundle: nil), forCellReuseIdentifier: lienListingReusableCellIdentifier)
        
        parseTaxLienData()
        
        // Confirm button
        confirmButtonFrame.layer.cornerRadius = 10
        confirmButtonFrame.clipsToBounds = true
        
        // Summary Frame
        summaryFrame.layer.cornerRadius = 30
        
        // Order summary
        numberOfLiensLabel.text = String(taxLiens.count)
        switch (investmentObjectiveOption) {
        case 2:
            annualReturnPercentLabel.text = "14.6%"
            annualReturnDollarLabel.text = "$3,213.91"
            break
        case 1:
            annualReturnPercentLabel.text = "18.6%"
            annualReturnDollarLabel.text = "$3,921.15"
            break
        case 0:
            annualReturnPercentLabel.text = "22.6%"
            annualReturnDollarLabel.text = "$4,973.91"
            break
        default:
            break
        }
        
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell = self.buildPortfolioTableView.dequeueReusableCell(withIdentifier: lienListingReusableCellIdentifier, for: indexPath) as! TaxLienListingTableViewCell
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
                vc.isModalInPresentation = true
            }
        }
    }
    
    func parseTaxLienData() {
        taxLiens = [
            TaxLien(number: 1004, county: "Miami", state: "Florida", price: 900.56, rate: 18, address: "9909 Smith Lane", city: "Hiealeah", zipcode: "33012"),
            TaxLien(number: 1008, county: "Cook", state: "Illinois", price: 269.07, rate: 36, address: "319 Elmwood St.", city: "Rockford", zipcode: "61104"),
            TaxLien(number: 1270, county: "Maricopa", state: "Arizona", price: 2777.27, rate: 16, address: "42 Hilltop St.", city: "Chino Valley", zipcode: "86323"),
            TaxLien(number: 1410, county: "Maricopa", state: "Arizona", price: 522.90, rate: 16, address: "99 Vernon Dr.", city: "Heber", zipcode: "85928"),
            TaxLien(number: 1488, county: "Maricopa", state: "Arizona", price: 420.11, rate: 16, address: "7431 South Walt Whitman Circle", city: "Gilbert", zipcode: "85233"),
            TaxLien(number: 1514, county: "Maricopa", state: "Arizona", price: 891.73, rate: 16, address: "709 Henry Street", city: "Bapchule", zipcode: "85221"),
            TaxLien(number: 2331, county: "Maricopa", state: "Arizona", price: 1892.11, rate: 16, address: "149 N. Bellow Avenue", city: "Palo Verde", zipcode: "85343"),
            TaxLien(number: 2333, county: "Miami", state: "Florida", price: 505.27, rate: 18, address: "9689 Jockey Hollow Street", city: "Eastlake Weir", zipcode: "32133"),
            TaxLien(number: 2390, county: "Miami", state: "Florida", price: 2711.44, rate: 18, address: "664 Meadowbrook Avenue", city: "Lady Lake", zipcode: "32159"),
            TaxLien(number: 2411, county: "Miami", state: "Florida", price: 599.21, rate: 18, address: "9893 S. Evergreen Ave.", city: "Melbourne", zipcode: "32940"),
            TaxLien(number: 3002, county: "Miami", state: "Florida", price: 443.10, rate: 18, address: "7158 Seacoast St.", city: "High Springs", zipcode: "32643"),
            TaxLien(number: 3110, county: "Miami", state: "Florida", price: 822.00, rate: 18, address: "550 East Bank Ave.", city: "Lulu", zipcode: "32061"),
            TaxLien(number: 3770, county: "Maricopa", state: "Arizona", price: 920.00, rate: 16, address: "70 N. Ironwood Ave.", city: "Tucson", zipcode: "85757"),
            TaxLien(number: 4299, county: "Maricopa", state: "Arizona", price: 1011.22, rate: 16, address: "9227 West Champion St.", city: "Phoenix", zipcode: "85037"),
            TaxLien(number: 4891, county: "Maricopa", state: "Arizona", price: 107.20, rate: 16, address: "999 New St.", city: "Glendale", zipcode: "85306"),
            TaxLien(number: 5522, county: "Miami", state: "Florida", price: 1134.55, rate: 18, address: "196 Second Street", city: "High Springs", zipcode: "32655"),
            TaxLien(number: 5982, county: "Miami", state: "Florida", price: 272.90, rate: 18, address: "45 Pearl Dr.", city: "Sebastian", zipcode: "32976"),
            TaxLien(number: 7001, county: "Maricopa", state: "Arizona", price: 953.20, rate: 16, address: "6 Lakewood Circle", city: "Kingman", zipcode: "86402"),
            TaxLien(number: 7555, county: "Maricopa", state: "Arizona", price: 855.34, rate: 16, address: "92 Ridge Street", city: "Chandler", zipcode: "85226"),
            TaxLien(number: 7990, county: "Cook", state: "Illinois", price: 721.89, rate: 36, address: "8185 Rowan Drive", city: "Silvis", zipcode: "61282"),
            TaxLien(number: 9200, county: "Miami", state: "Florida", price: 1957.33, rate: 18, address: "4 Stonybrook Drive", city: "Altha", zipcode: "32421"),
            TaxLien(number: 9271, county: "Miami", state: "Florida", price: 801.36, rate: 18, address: "7 Fountain Avenue ", city: "Lakeland", zipcode: "33806"),
            TaxLien(number: 9811, county: "Maricopa", state: "Arizona", price: 510.24, rate: 16, address: "40 N. Lookout Avenue", city: "Wickenburg", zipcode: "85390")
        ]
        lienListingsCellsViewModels = convertTaxLienToLienListingCellViewModels(taxLiens: taxLiens)
    }
}
