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
    @IBOutlet weak var BuyButton: UIButton!
    @IBOutlet weak var ProjectedEarningsChart: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        let sep = ["", "2", "4", "6", "8"]
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

    
    @IBAction func BackButtonPressed(_ sender: UIBarButtonItem) {
        //self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        var dataEntries: [ChartDataEntry] = []
//        for i in 0..<5 {
//            let dataEntry = ChartDataEntry(x: Double(i), y: Double(i))
//            dataEntries.append(dataEntry)
//        }
//        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
//        let lineChartData = LineChartData(dataSet: lineChartDataSet)
//
//        lineChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.self.height)
//        lineChart.center = view.center
//        view.addSubview(lineChart)
//        lineChartDataSet.colors = ChartColorTemplates.joyful()
//        lineChart.legend.enabled = false
//        lineChart.data = lineChartData
//        lineChart.drawGridBackgroundEnabled = false
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
