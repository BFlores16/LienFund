//
//  FilterViewController.swift
//  LienFund
//
//  Created by Brando Flores on 4/24/22.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var FilterOptionsTableView: UITableView!
    let FilterOptionsTableViewCellIdentifier = "FilterOptionTableViewCell"
    let filterOptionNames = [ "Price", "Interest Rate", "County", "State", "Time Until Expiration", "Expected Annual Return" ]
    @IBOutlet weak var applyButtonFrame: UIView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterOptionNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = self.FilterOptionsTableView.dequeueReusableCell(withIdentifier: FilterOptionsTableViewCellIdentifier, for: indexPath) as! FilterOptionTableViewCell
        cell.selectionStyle = .none
        
        cell.FilterOptionName.text = filterOptionNames[indexPath.row]
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        applyButtonFrame.layer.cornerRadius = 10
        FilterOptionsTableView.delegate = self
        FilterOptionsTableView.dataSource = self
    }
    
    @IBAction func dismissFilterScreen(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

}
