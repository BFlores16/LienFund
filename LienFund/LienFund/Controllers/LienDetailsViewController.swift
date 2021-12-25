//
//  LienDetailsViewController.swift
//  LienFund
//
//  Created by Brando Flores on 12/3/21.
//

import UIKit
import Charts

class LienDetailsViewController: UIViewController, ChartViewDelegate {

    var lineChart = LineChartView()
    var taxLien:TaxLien? = nil

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
        SetupUI()
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

    func SetupUI() {
        // Tax lien details
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        if taxLien != nil {
            TaxLienNumber.text = String(taxLien?.number ?? 0)
            TaxLienPrice.text = currencyFormatter.string(from: NSNumber(value: taxLien?.price ?? 0.0))
            TaxLienPercentAnnual.text = String(format: "%.1f%%", taxLien?.rate ?? 0.0)
        }
        
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

        // Button
//        AddButtonFrame.layer.borderColor = UIColor.lightGray.cgColor
//        AddButtonFrame.layer.borderWidth = 1.0
        AddButtonFrame.addBorder(toSide: UIView.ViewSide.Top, color: UIColor.lightGray.cgColor, thickness: 1.0)
//        AddButtonFrame.addBorder(toSide: UIView.ViewSide.Bottom, color: UIColor.lightGray.cgColor, thickness: 1.0)
        AddToPortfolioButton.layer.cornerRadius = 10
        
    }
    
    @IBAction func BackButtonPressed(_ sender: UIBarButtonItem) {
        //self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
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
