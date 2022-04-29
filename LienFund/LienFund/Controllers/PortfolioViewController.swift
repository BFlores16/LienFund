//
//  PortfolioViewController.swift
//  LienFund
//
//  Created by Brando Flores on 12/8/21.
//

import UIKit
import Charts
import SQLite

class PortfolioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChartViewDelegate {
        
    final let LIENS_DATA_FILE = "liens_data"
    var taxLiens = [TaxLien]()
    var lienListingsCellsViewModels = [LienListingCellViewModel]()
    let lienListingReusableCellIdentifier = "TaxLienListingTableViewCell"
    let NC = NotificationCenter.default
    
    // Database
    let lienListingsDB = ListingsTable()
    let portfolioDB = PortfolioTable()
    let purchasedDB = PurchasedTable()
    
    var lineChart = LineChartView()
    @IBOutlet weak var BuyButton: UIButton!
    @IBOutlet weak var ProjectedEarningsChartFrame: UIView!
    @IBOutlet weak var ProjectedEarningsChart: LineChartView!
    @IBOutlet weak var taxLienListingsTableView: UITableView!
    var myLiensIsExpanded = true
    
    @IBOutlet weak var MyLiensButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NC.addObserver(self, selector: #selector(portfolioChanged), name: Notification.Name(Strings.NCPortfolioChanged), object: nil)
        
        // Table view
        taxLienListingsTableView.delegate = self
        taxLienListingsTableView.dataSource = self
        taxLienListingsTableView.register(UINib(nibName: lienListingReusableCellIdentifier, bundle: nil), forCellReuseIdentifier: lienListingReusableCellIdentifier)
        
        // Do any additional setup after loading the view.
        BuyButton.layer.cornerRadius = 10
        
        parseTaxLienData()
        updateBuyButton()
        if taxLiens.count > 0 {
            updateChart()
        }
        customizeChart()
    }
    
    func updateChart() {
        // Supply data
        var entries = [BarChartDataEntry]()
        var expirations = [Int]()
        let totalTaxLiensCost = taxLiens.reduce(0) {$0 + $1.price}
        
        for lien in taxLiens {
            let expiration = Int(Expirations.C[lien.state ]!)!
            expirations.append(expiration)
        }
        //let minimumExpiration = expirations.min()
        let maximumExpiration = expirations.max() ?? 0
        
        let earnings = calculateAnnualEarnings(longestExpiration: maximumExpiration)

        for x in 1...earnings.count {
            entries.append(BarChartDataEntry(x: Double(x), yValues: [totalTaxLiensCost, earnings[x - 1]]))
        }
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        let set = BarChartDataSet(entries: entries)
        set.colors = [
            NSUIColor(cgColor: UIColor.lightGray.cgColor),
            NSUIColor(cgColor: UIColor.init(named: "CustomOrange")!.cgColor),
            NSUIColor(cgColor: UIColor.lightGray.cgColor),
            NSUIColor(cgColor: UIColor.init(named: "CustomYellow")!.cgColor),
            NSUIColor(cgColor: UIColor.lightGray.cgColor),
            NSUIColor(cgColor: UIColor.init(named: "CustomGreen")!.cgColor)
        ]
        
        let data = BarChartData(dataSet: set)
        data.setValueFormatter(DefaultValueFormatter.init(formatter: currencyFormatter))
        let storedLegendEntries = [
            LegendEntry(label: "1 Year", form: .line, formSize: CGFloat.nan, formLineWidth: .nan, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: NSUIColor.init(named: "CustomOrange")),
            LegendEntry(label: "2 Years", form: .line, formSize: CGFloat.nan, formLineWidth: .nan, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: NSUIColor.init(named: "CustomYellow")),
            LegendEntry(label: "3 Years", form: .line, formSize: CGFloat.nan, formLineWidth: .nan, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: NSUIColor.init(named: "CustomGreen"))
        ]

        var legendEntries = [LegendEntry]()
        for entry in 0...maximumExpiration - 1 {
            legendEntries.append(storedLegendEntries[entry])
        }
        ProjectedEarningsChart.legend.setCustom(entries: legendEntries)
        
        ProjectedEarningsChart.leftAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: currencyFormatter)
        ProjectedEarningsChart.data?.setValueFormatter(DefaultValueFormatter.init(formatter: currencyFormatter))

        // Set Storyboard chart
        ProjectedEarningsChart.data = data
    }
    
    func customizeChart() {
        ProjectedEarningsChart.leftAxis.drawGridLinesEnabled = false
        ProjectedEarningsChart.leftAxis.drawAxisLineEnabled = false
        ProjectedEarningsChart.rightAxis.drawAxisLineEnabled = false
        ProjectedEarningsChart.xAxis.enabled = false
        ProjectedEarningsChart.rightAxis.enabled = false
        ProjectedEarningsChart.highlightPerTapEnabled = false
        ProjectedEarningsChart.dragEnabled = false
        ProjectedEarningsChart.isUserInteractionEnabled = false
        
        ProjectedEarningsChartFrame.layer.cornerRadius = 10
        ProjectedEarningsChartFrame.layer.shadowColor = UIColor.black.cgColor
        ProjectedEarningsChartFrame.layer.shadowOpacity = 0.4
        ProjectedEarningsChartFrame.layer.shadowRadius = 4.0
        ProjectedEarningsChartFrame.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    }
    
    func calculateAnnualEarnings(longestExpiration: Int) -> [Double]{
        var earnings = [Double](repeating: 0.0, count: longestExpiration)
        
        for lien in taxLiens {
            let dollarInterest = lien.price * (lien.rate / 100.0)
            let years: Int = Int(Expirations.C[lien.state ]!) ?? 1
            for year in 1...years {
                earnings[year - 1] = (Double(year) * dollarInterest)
            }
        }
        
        return earnings
    }
    
    func parseTaxLienData() {
        taxLiens = self.portfolioDB.GetTaxLiens()
        lienListingsCellsViewModels = convertTaxLienToLienListingCellViewModels(taxLiens: taxLiens)
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
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LienDetailsViewController") as! LienDetailsViewController
        navigationController?.pushViewController(vc, animated: true)
        vc.taxLien = taxLiens[indexPath.section]
        taxLienListingsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func portfolioChanged() {
        parseTaxLienData()
        taxLienListingsTableView.reloadData()
        updateBuyButton()
        if taxLiens.count > 0 {
            updateChart()
        } else {
            ProjectedEarningsChart.clear()
        }
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
    
    @IBAction func MyLiensButtonPressed(_ sender: UIButton) {
        var angle = 0.0
        myLiensIsExpanded = !myLiensIsExpanded
        if (!myLiensIsExpanded) {
            angle = Double.pi
        } else {
            angle = Double.pi - 3.14149
        }
        UIView.animate(withDuration: 0.25) {
            self.MyLiensButton.transform = CGAffineTransform(rotationAngle: angle)
        }
        
        if (taxLienListingsTableView.isHidden) {
            taxLienListingsTableView.alpha = 0
            taxLienListingsTableView.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.taxLienListingsTableView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: { [self] in
                taxLienListingsTableView.alpha = 0
            }) { [self] (finished) in
                taxLienListingsTableView.isHidden = finished
            }
        }
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
    
    @IBAction func BuyButtonPressed(_ sender: UIButton) {
//        let completedAlert = UIAlertController(title: "Purchase Completed", message: "Your purchase has been confirmed. Lienfund will review your request and follow up with further instructions.", preferredStyle: UIAlertController.Style.alert)
//        completedAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//        
//        // create the alert
//        let confirmAlert = UIAlertController(title: "Confirm", message: "Are you sure you would like to submit your porfolio purchase request to Lienfund?", preferredStyle: UIAlertController.Style.alert)
//        // add the actions (buttons)
//        confirmAlert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { UIAlertAction in
//            print("Portfolio Purchase Confirmed")
//            for lien in self.taxLiens {
//                _ = self.purchasedDB.AddLien(taxLien: lien)
//            }
//            self.portfolioDB.ClearTable()
//            self.parseTaxLienData()
//            self.taxLienListingsTableView.reloadData()
//            self.NC.post(name: Notification.Name(Strings.NCPortfolioPurchaseCompleted), object: nil)
//            self.present(completedAlert, animated: true, completion: nil)
//        }))
//        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
//
//        // show the alert
//        self.present(confirmAlert, animated: true, completion: nil)
    }
    
    func updateBuyButton() {
        if (self.taxLiens.isEmpty) {
            BuyButton.isEnabled = false
            BuyButton.tintColor = UIColor.lightGray
        } else {
            BuyButton.isEnabled = true
            BuyButton.tintColor = UIColor.init(named: "GreenBackground")
        }
    }
}
