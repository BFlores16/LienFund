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
    var lineChart = BarChartView()
    var taxLien:TaxLien? = nil
    var isInPortfolio: Bool = false
    let lienListingsDB = ListingsTable()
    let portfolioDB = PortfolioTable()
    
    let NC = NotificationCenter.default

    // Chart
    @IBOutlet weak var ProjectedEarningsChartFrame: UIView!
    @IBOutlet weak var ExampleLienImage: UIImageView!
    
    @IBOutlet weak var ProjectedEarningsChart: BarLineChartViewBase!
    
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
        
        if taxLien?.number == 566 {
            ExampleLienImage.isHidden = false
            ProjectedEarningsChart.isHidden = true
        }
        
        SetupUI()
        setupLabels()
        createChart()
    }
    
    func createChart() {
        // Supply data
        var entries = [BarChartDataEntry]()
        let earnings = calculateAnnualEarnings()
        for x in 1...earnings.count {
            entries.append(            BarChartDataEntry(x: Double(x), yValues: [taxLien!.price, earnings[x - 1]]))
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
            NSUIColor(cgColor: UIColor.init(named: "CustomGreen")!.cgColor),
            NSUIColor(cgColor: UIColor.lightGray.cgColor),
            NSUIColor(cgColor: UIColor.init(named: "GreenBackground")!.cgColor)
        ]
        
        let data = BarChartData(dataSet: set)
        data.setValueFormatter(DefaultValueFormatter.init(formatter: currencyFormatter))
        let storedLegendEntries = [
            LegendEntry(label: "1 Year", form: .line, formSize: CGFloat.nan, formLineWidth: .nan, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: NSUIColor.init(named: "CustomOrange")),
            LegendEntry(label: "2 Years", form: .line, formSize: CGFloat.nan, formLineWidth: .nan, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: NSUIColor.init(named: "CustomGreen")),
            LegendEntry(label: "3 Years", form: .line, formSize: CGFloat.nan, formLineWidth: .nan, formLineDashPhase: .nan, formLineDashLengths: .none, formColor: NSUIColor.init(named: "GreenBackground"))
        ]
        let expiration = Int(Expirations.C[taxLien?.state ?? "1"]!)!
        var legendEntries = [LegendEntry]()
        for entry in 0...expiration - 1 {
            legendEntries.append(storedLegendEntries[entry])
        }
        ProjectedEarningsChart.legend.setCustom(entries: legendEntries)
        
        ProjectedEarningsChart.leftAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: currencyFormatter)
        ProjectedEarningsChart.data?.setValueFormatter(DefaultValueFormatter.init(formatter: currencyFormatter))

        // Set Storyboard chart
        ProjectedEarningsChart.data = data
        
        // Customize legend/labels
        customizeChart()
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
    }
    
    func calculateAnnualEarnings() -> [Double]{
        var earnings = [Double]()
        let dollarInterest = taxLien!.price * (taxLien!.rate / 100.0)
        let years: Int = Int(Expirations.C[taxLien?.state ?? "1"]!) ?? 1
        for year in 1...years {
            earnings.append(Double(year) * dollarInterest)
        }
        
        return earnings
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
            let monthlyRate = taxLien!.rate / 12.0
            TaxLienPercentMonthly.text = String(format: "%.1f%%", monthlyRate) + " (monthly)"
            TaxLienExpectedAnnualReturn.text = currencyFormatter.string(from: NSNumber(value: taxLien!.price * (taxLien!.rate / 100.0)))!
            TaxLienAddress.text = taxLien?.address
            TaxLienCityState.text = (taxLien!.city + ", " + taxLien!.state)
            TaxLienZipCode.text = taxLien?.zipcode
            TaxLienTimeUntilExpiration.text = Expirations.C[taxLien?.state ?? ""]! + " year(s)"
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
