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
        
        taxLienListingsTableView.delegate = self
        taxLienListingsTableView.dataSource = self
        taxLienListingsTableView.register(UINib(nibName: lienListingReusableCellIdentifier, bundle: nil), forCellReuseIdentifier: lienListingReusableCellIdentifier)
        
        // Do any additional setup after loading the view.
        BuyButton.layer.cornerRadius = 10

        lineChart.delegate = self
        // Do any additional setup after loading the view.
        var dataEntries: [ChartDataEntry] = []
        for i in 10..<20 {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(i))
            dataEntries.append(dataEntry)
        }

        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.lineWidth = 5
        lineChartDataSet.colors = [UIColor.white]
        ProjectedEarningsChart.data = lineChartData
        ProjectedEarningsChart.legend.enabled = false
        ProjectedEarningsChart.xAxis.drawGridLinesEnabled = false
        ProjectedEarningsChart.xAxis.drawAxisLineEnabled = false
        ProjectedEarningsChart.leftAxis.drawGridLinesEnabled = false
        ProjectedEarningsChart.leftAxis.drawAxisLineEnabled = false
        ProjectedEarningsChart.rightAxis.drawGridLinesEnabled = false
        ProjectedEarningsChart.rightAxis.drawAxisLineEnabled = false
        ProjectedEarningsChart.rightAxis.drawZeroLineEnabled = false
        
        ProjectedEarningsChart.xAxis.enabled = false
        ProjectedEarningsChart.rightAxis.enabled = false
        ProjectedEarningsChart.highlightPerTapEnabled = false
        ProjectedEarningsChart.dragEnabled = false
        ProjectedEarningsChart.isUserInteractionEnabled = false
        
        let gradientColors = [UIColor.green.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        lineChartDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        lineChartDataSet.drawFilledEnabled = true // Draw the Gradient
        
        ProjectedEarningsChartFrame.layer.cornerRadius = 10
        ProjectedEarningsChartFrame.layer.shadowColor = UIColor.black.cgColor
        ProjectedEarningsChartFrame.layer.shadowOpacity = 0.4
        ProjectedEarningsChartFrame.layer.shadowRadius = 4.0
        ProjectedEarningsChartFrame.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        
        parseTaxLienData()
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
}
