//
//  PortfolioViewController.swift
//  LienFund
//
//  Created by Brando Flores on 12/8/21.
//

import UIKit
import Charts

class PortfolioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChartViewDelegate {
    let lienListings: [LienListingCellViewModel] = [
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: String(866.24), rate: "16.0"),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: "866.24", rate: "16.0"),
        LienListingCellViewModel(number: 1000, state: "AZ", county: "Maricopa", price: "866.24", rate: "16.0")
    ]
    
    var lineChart = LineChartView()
    @IBOutlet weak var BuyButton: UIButton!
    @IBOutlet weak var ProjectedEarningsChart: LineChartView!
    @IBOutlet weak var ListingsTableView: UITableView!
    @IBOutlet weak var PortfolioScrollView: UIScrollView!
    var myLiensIsExpanded = true
    let lienListingReusableCellIdentifier = "LienListCell"
    
    @IBOutlet weak var MyLiensButton: UIButton!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lienListings.count
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
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let lienDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "lienDetailsViewController") as! LienDetailsViewController
        
        let indexPath = self.ListingsTableView.indexPathForSelectedRow
        lienDetailsViewController.taxLien = TaxLien(number: 4899, county: "Maricopa", state: "AZ", price: 1016.24, rate: 16)
        
        self.navigationController?.pushViewController(lienDetailsViewController, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBarController?.viewDidLoad()
        ListingsTableView.delegate = self
        ListingsTableView.dataSource = self
    
        
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
        
        if (ListingsTableView.isHidden) {
            ListingsTableView.alpha = 0
            ListingsTableView.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.ListingsTableView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: { [self] in
                ListingsTableView.alpha = 0
            }) { [self] (finished) in
                ListingsTableView.isHidden = finished
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
