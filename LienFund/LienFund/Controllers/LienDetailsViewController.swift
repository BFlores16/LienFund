//
//  LienDetailsViewController.swift
//  LienFund
//
//  Created by Brando Flores on 12/3/21.
//

import UIKit
import Charts
import SQLite

class LienDetailsViewController: UIViewController, ChartViewDelegate {
    var lineChart = LineChartView()
    var taxLien:TaxLien? = nil
    var isInPortfolio: Bool = false
    let lienListingsDB = ListingsTable()
    let portfolioDB = PortfolioTable()
    
    let NC = NotificationCenter.default

    // Chart
    @IBOutlet weak var ProjectedEarningsChartFrame: UIView!
    @IBOutlet weak var ProjectedEarningsChart: LineChartView!
    
    // Header
    @IBOutlet weak var TaxLienDetailsHeaderFrame: UIView!
    @IBOutlet weak var TaxLienNumberHeader: UILabel!
    @IBOutlet weak var TaxLienLocationHeader: UILabel!
    @IBOutlet weak var TaxLienPriceHeader: UILabel!
    @IBOutlet weak var TaxLienPercentHeader: UILabel!
    
    // Details
    @IBOutlet weak var TaxLiensDetailsFrame: UIView!
    @IBOutlet weak var TaxLienNumber: UILabel!
    @IBOutlet weak var TaxLienPrice: UILabel!
    @IBOutlet weak var TaxLienPercentAnnual: UILabel!
    @IBOutlet weak var TaxLienPercentMonthly: UILabel!
    @IBOutlet weak var TaxLienExpectedAnnualReturn: UILabel!
    @IBOutlet weak var TaxLienAddress: UILabel!
    @IBOutlet weak var TaxLienCityState: UILabel!
    @IBOutlet weak var TaxLienZipCode: UILabel!
    @IBOutlet weak var TaxLienTimeUntilExpiration: UILabel!
    
    // Button
    @IBOutlet weak var AddButtonFrame: UIView!
    @IBOutlet weak var AddToPortfolioButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NC.addObserver(self, selector: #selector(portfolioChanged), name: Notification.Name(Strings.NCPortfolioChanged), object: nil)
        
        SetupUI()
        setupLabels()
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
        lineChartDataSet.colors = [UIColor.green]
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
        
        
    }
    
    func setupLabels() {
        // Tax lien details
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        if taxLien != nil {
            let number = String(taxLien?.number ?? 0)
            let price = currencyFormatter.string(from: NSNumber(value: taxLien?.price ?? 0.0))!
            let annualPercent = String(format: "%.1f%%", taxLien?.rate ?? 0.0)
            
            // Header
            TaxLienNumberHeader.text = "#" + number
            TaxLienPriceHeader.text = price
            TaxLienPercentHeader.text = annualPercent
            TaxLienLocationHeader.text = taxLien!.county + ", " + taxLien!.state
            
            // Body
            TaxLienNumber.text = number
            TaxLienPrice.text = price
            TaxLienPercentAnnual.text = annualPercent + " (annually)"
            let monthlyRate = taxLien!.rate / 2.0
            TaxLienPercentMonthly.text = String(format: "%.1f%%", monthlyRate) + " (monthly)"
            TaxLienExpectedAnnualReturn.text = currencyFormatter.string(from: NSNumber(value: taxLien?.price ?? 0.0 / 4.0))!
            TaxLienAddress.text = taxLien?.address
            TaxLienCityState.text = (taxLien!.city + ", " + taxLien!.state)
            TaxLienZipCode.text = taxLien?.zipcode
            TaxLienTimeUntilExpiration.text = Expirations.C[taxLien?.state ?? ""]
        }
    }

    func SetupUI() {
        // Tax lien chart
        ProjectedEarningsChartFrame.layer.cornerRadius = 10
        ProjectedEarningsChartFrame.layer.shadowColor = UIColor.black.cgColor
        ProjectedEarningsChartFrame.layer.shadowOpacity = 0.4
        ProjectedEarningsChartFrame.layer.shadowRadius = 4.0
        ProjectedEarningsChartFrame.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        
        // Details Header
        TaxLienDetailsHeaderFrame.layer.cornerRadius = 10
        TaxLienDetailsHeaderFrame.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        TaxLienDetailsHeaderFrame.clipsToBounds = true
        
        // Details Frame
        TaxLiensDetailsFrame.layer.cornerRadius = 10
        TaxLiensDetailsFrame.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        TaxLiensDetailsFrame.layer.shadowColor = UIColor.black.cgColor
        TaxLiensDetailsFrame.layer.shadowOpacity = 0.4
        TaxLiensDetailsFrame.layer.shadowRadius = 4.0
        TaxLiensDetailsFrame.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)

        // Portfolio button
        AddButtonFrame.addBorder(toSide: UIView.ViewSide.Top, color: UIColor.lightGray.cgColor, thickness: 1.0)
        AddToPortfolioButton.layer.cornerRadius = 10
        let lienNumber = self.portfolioDB.CheckLienExists(taxLien: self.taxLien!)
        if (lienNumber == nil) {
            isInPortfolio = false
            updatePortfolioButton()
        } else {
            isInPortfolio = true
            updatePortfolioButton()
        }
    }
    
    @objc func portfolioChanged() {
        isInPortfolio = !isInPortfolio
        updatePortfolioButton()
    }
    
    func updatePortfolioButton() {
        if (isInPortfolio) {
            AddToPortfolioButton.tintColor = UIColor.red
            AddToPortfolioButton.setTitle("Remove From Portfolio", for: .normal)
        } else {
            AddToPortfolioButton.tintColor = UIColor.init(named: "GreenBackground")
            AddToPortfolioButton.setTitle("Add To Portfolio", for: .normal)
        }
    }

    
    @IBAction func BackButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AddButtonClicked(_ sender: UIButton) {
        if (isInPortfolio) {
            _ = self.portfolioDB.DeleteLien(taxLien: self.taxLien!)
            _ = self.lienListingsDB.AddLien(taxLien: self.taxLien!)
//            isInPortfolio = false
            //updatePortfolioButton()
        } else {
            _ = self.portfolioDB.AddLien(taxLien: self.taxLien!)
            _ = self.lienListingsDB.DeleteLien(taxLien: self.taxLien!)
//            isInPortfolio = true
            //updatePortfolioButton()
        }
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(Strings.NCPortfolioChanged), object: nil)
    }
}

extension UIView {
    enum ViewSide {
        case Left, Right, Top, Bottom
    }

    func addBorder(toSide side: ViewSide, color: CGColor, thickness: CGFloat) {

        let border = CALayer()
        border.backgroundColor = color

        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }

        layer.addSublayer(border)
    }
}
