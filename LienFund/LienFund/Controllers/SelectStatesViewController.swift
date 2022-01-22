//
//  SelectStatesViewController.swift
//  LienFund
//
//  Created by Brando Flores on 1/18/22.
//

import UIKit

protocol StatesSelectedDelegate : AnyObject {
    func StatesSelected(statesList: [(stateName: String, isChecked: Bool)], selectedStates: [(stateName: String, isChecked: Bool)])
}

class SelectStatesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var stateListTableView: UITableView!
    weak var delegate: StatesSelectedDelegate?
    let lienListingReusableCellIdentifier = "StateCell"
    var selectedStates: [(stateName: String, isChecked: Bool)]? = []
    var statesList: [(stateName: String, isChecked: Bool)]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    
        stateListTableView.delegate = self
        stateListTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.tintColor = UIColor.init(named: "GreenBackground")
        self.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(systemName: "arrow.backward")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(dismissPage))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.StatesSelected(statesList: statesList!, selectedStates: selectedStates!)
    }
    
    @objc func dismissPage() {
        self.navigationController?.dismiss(animated: true, completion: nil)
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
        if (cell.isChecked) {
            cell.checkButton.setImage(UIImage.init(systemName: "checkmark.square"), for: .normal)
        } else {
            cell.checkButton.setImage(UIImage.init(systemName: "square"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        statesList![indexPath.row].isChecked = !statesList![indexPath.row].isChecked
        let cell = self.stateListTableView.dequeueReusableCell(withIdentifier: lienListingReusableCellIdentifier, for: indexPath) as! StateTableViewCell
        cell.isChecked = !cell.isChecked
        
        if (statesList![indexPath.row].isChecked) {
            selectedStates?.append(statesList![indexPath.row])
        } else {
            selectedStates?.removeAll(where: {$0.stateName == statesList![indexPath.row].stateName})
        }

        stateListTableView.reloadData()

        stateListTableView.deselectRow(at: indexPath, animated: true)
    }
}
