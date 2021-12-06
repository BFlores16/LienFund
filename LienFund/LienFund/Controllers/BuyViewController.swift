//
//  ViewController.swift
//  LienFund
//
//  Created by Brando Flores on 11/7/21.
//

import UIKit

class BuyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let lienListings: [LienListingCellViewModel] = [
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: 866.24, rate: 16.0)
    ]

    @IBOutlet weak var ListingsTableView: UITableView!
    let lienListingReusableCellIdentifier = "LienListCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // This view controller itself will provide the delegate methods and row data for the table view.
        ListingsTableView.delegate = self
        ListingsTableView.dataSource = self
    }
    
    // number of rows in table view
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.lienListings.count
     }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     // create a cell for each table view row
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         // create a new cell if needed or reuse an old one
         let cell = self.ListingsTableView.dequeueReusableCell(withIdentifier: "LienListCell", for: indexPath) as! LienListingTableViewCell
             
         
         cell.LienNumberLabel.text = "# " + String(self.lienListings[indexPath.row].number)
         cell.LienLocationLabel.text = self.lienListings[indexPath.row].county + ", " + self.lienListings[indexPath.row].state
         cell.InterestRateLabel.text = String(self.lienListings[indexPath.row].rate) + "%"
         // set the text from the data model
//         cell.textLabel?.text = self.animals[indexPath.row]
         
         
         return cell
     }
     
     // method to run when table view cell is tapped
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         print("You tapped cell number \(indexPath.row).")
     }
}


