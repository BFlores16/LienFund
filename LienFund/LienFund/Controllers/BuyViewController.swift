//
//  ViewController.swift
//  LienFund
//
//  Created by Brando Flores on 11/7/21.
//

import UIKit

class BuyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    final let LIENS_DATA_FILE = "liens_data"
    var taxLiens = [TaxLien]()
    var lienListingsCellsViewModels = [LienListingCellViewModel]()

    @IBOutlet weak var ListingsTableView: UITableView!
    let lienListingReusableCellIdentifier = "LienListCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taxLiens = convertToLiensListings(liensData: readTxtFile(fileName: LIENS_DATA_FILE))
        lienListingsCellsViewModels = convertTaxLienToLienListingCellViewModels(taxLiens: taxLiens)
        // This view controller itself will provide the delegate methods and row data for the table view.
        ListingsTableView.delegate = self
        ListingsTableView.dataSource = self
    }
    
    // number of rows in table view
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.lienListingsCellsViewModels.count
     }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     // create a cell for each table view row
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         // create a new cell if needed or reuse an old one
         let cell = self.ListingsTableView.dequeueReusableCell(withIdentifier: "LienListCell", for: indexPath) as! LienListingTableViewCell
             
         
         cell.LienNumberLabel.text = "# " + String(self.lienListingsCellsViewModels[indexPath.row].number)
         cell.LienLocationLabel.text = self.lienListingsCellsViewModels[indexPath.row].county + ", " + self.lienListingsCellsViewModels[indexPath.row].state
         cell.LienPriceLabel.text = "$" + String(self.lienListingsCellsViewModels[indexPath.row].price)
         cell.InterestRateLabel.text = String(self.lienListingsCellsViewModels[indexPath.row].rate) + "%"
         // set the text from the data model
//         cell.textLabel?.text = self.animals[indexPath.row]
         
         
         return cell
     }
     
     // method to run when table view cell is tapped
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         print("You tapped cell number \(indexPath.row).")
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
        for lien in taxLiens {
            viewModels.append(LienListingCellViewModel(number: lien.number, state: lien.state, county: lien.county, price: String(format: "%.02f", lien.price), rate: String(format: "%.1f%", lien.rate)))
        }
        return viewModels
    }
}


