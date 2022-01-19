//
//  SelectStatesViewController.swift
//  LienFund
//
//  Created by Brando Flores on 1/18/22.
//

import UIKit

class SelectStatesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var stateListTableView: UITableView!
    let lienListingReusableCellIdentifier = "StateCell"
    var statesList: [(stateName: String, isChecked: Bool)]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        statesList = createStatesList()
        stateListTableView.delegate = self
        stateListTableView.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statesList?.count ?? 0
    }
    
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = self.stateListTableView.dequeueReusableCell(withIdentifier: lienListingReusableCellIdentifier, for: indexPath) as! StateTableViewCell
        cell.selectionStyle = .none
        
        cell.stateName.text = statesList?[indexPath.row].stateName
        cell.isChecked = statesList?[indexPath.row].isChecked ?? false

        return cell
    }
    

//    "Nevada":"NV",
//    "New Hampshire":"NH",
//    "New Jersey":"NJ",
//    "New Mexico":"NM",
//    "New York":"NY",
//    "North Carolina":"NC",
//    "North Dakota":"ND",
//    "Ohio":"OH",
//    "Oklahoma":"OK",
//    "Oregon":"OR",
//    "Pennsylvania":"PA",
//    "Rhode Island":"RI",
//    "South Dakota":"SD",
//    "Tennessee":"TN",
//    "Texas":"TX",
//    "Utah":"UT",
//    "Vermont":"VT",
//    "Virginia":"VA",
//    "Washington":"WA",
//    "West Virginia":"WV",
//    "Wisconsin":"WI",
//    "Wyoming":"WY"
    
    func createStatesList() -> [(stateName: String, isChecked: Bool)] {
        return [("Alabama", false),("Alask", false),("Arizona", false),("Arkansas", false)
                ,("California", false),("Colorado", false),("Connecticut", false),("Delaware", false)
                ,("Florida", false),("Georgia", false),("Hawaii", false),("Idaho", false)
                ,("Illinois", false),("Indiana", false),("Iowa", false),("Kansas", false)]
    }
    
    //    "Alabama":"AL",
    //    "Alaska":"AK",
    //    "Arizona":"AZ",
    //    "Arkansas":"AR",
    //    "California":"CA",
    //    "Colorado":"CO",
    //    "Connecticut":"CT",
    //    "Delaware":"DE",
    //    "Florida":"FL",
    //    "Georgia":"GA",
    //    "Hawaii":"HI",
    //    "Idaho":"ID",
    //    "Illinois":"IL",
    //    "Indiana":"IN",
    //    "Iowa":"IA",
    //    "Kansas":"KS",
    //    "Kentucky":"KY",
    //    "Louisiana":"LA",
    //    "Maine":"ME",
    //    "Maryland":"MD",
    //    "Massachusetts":"MA",
    //    "Michigan":"MI",
    //    "Minnesota":"MN",
    //    "Mississippi":"MS",
    //    "Missouri":"MO",
    //    "Montana":"MT",
    //    "Nebraska":"NE",
}
