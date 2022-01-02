//
//  AppDelegate.swift
//  LienFund
//
//  Created by Brando Flores on 11/7/21.
//

import UIKit
import SQLite

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    final let LIENS_DATA_FILE = "liens_data"
    
    func readTxtFile(fileName: String) -> [String] {
        var lines = [String]()

        if let dataURL = Bundle.main.url(forResource: fileName, withExtension: "txt") {
            if let data = try? String(contentsOf: dataURL) {
                lines = data.components(separatedBy: "\n")
            }
        }
        lines.remove(at: lines.count - 1)
        
        return lines
    }
    
    func createTaxLiensTable() {
        let liensData = readTxtFile(fileName: LIENS_DATA_FILE)
        
        // Wrap everything in a do...catch to handle errors
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true)

            let db = try Connection("\(path.first ?? "")/db.sqlite3")
            
            let taxLiensTable = Table("tax_liens")
            
            let delete = taxLiensTable.drop(ifExists: true)
            try db.run(delete)
            
            let id = Expression<Int64>("id")
            let lienNumber = Expression<Int>("lien_number")
            let county = Expression<String?>("county")
            let state = Expression<String>("state")
            let price = Expression<String>("price")
            let rate = Expression<String>("rate")
            let address = Expression<String>("address")
            let city = Expression<String>("city")
            let zipcode = Expression<String>("zipcode")
            
            try db.run(taxLiensTable.create { t in
                t.column(id, primaryKey: true)
                t.column(lienNumber, unique: true)
                t.column(county)
                t.column(state)
                t.column(price)
                t.column(rate)
                t.column(address)
                t.column(city)
                t.column(zipcode)
            })
            
            for lien in liensData {
                let lienElements = lien.split(separator: ",")

                let number = Int(lienElements[0]) ?? 0
                let _county = String(lienElements[1])
                let _state = String(lienElements[2])
                let _price = String(lienElements[3])
                let _rate = String(lienElements[4])
                let _address = String(lienElements[5])
                let _city = String(lienElements[6])
                let _zipcode = String(lienElements[7])
                
                let insert = taxLiensTable.insert(lienNumber <- number, county <- _county, state <- _state, price <- _price, rate <- _rate, address <- _address, city <- _city, zipcode <- _zipcode)
                try db.run(insert)
                
                for lien in try db.prepare(taxLiensTable) {
                    print("lienNumber: \(lien[lienNumber]), county: \(String(describing: lien[county])), state: \(lien[state]), price: \(lien[price]), rate: \(lien[rate]), address: \(lien[address]), city: \(lien[city]), zipcode: \(lien[zipcode])")
                }
            }
        } catch {
            print (error)
        }
    }
    
    func createPortfolioTable() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true)

            let db = try Connection("\(path.first ?? "")/db.sqlite3")
            
            let portfolioTable = Table("portfolio")
            
            let delete = portfolioTable.drop(ifExists: true)
            try db.run(delete)
            
            let id = Expression<Int64>("id")
            let lienNumber = Expression<Int>("lien_number")
            let county = Expression<String?>("county")
            let state = Expression<String>("state")
            let price = Expression<String>("price")
            let rate = Expression<String>("rate")
            let address = Expression<String>("address")
            let city = Expression<String>("city")
            let zipcode = Expression<String>("zipcode")
            
            try db.run(portfolioTable.create { t in
                t.column(id, primaryKey: true)
                t.column(lienNumber, unique: true)
                t.column(county)
                t.column(state)
                t.column(price)
                t.column(rate)
                t.column(address)
                t.column(city)
                t.column(zipcode)
            })
        } catch {
            print (error)
        }
    }
    
    func createPurchasedTable() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true)

            let db = try Connection("\(path.first ?? "")/db.sqlite3")
            
            let purchasedTable = Table("purchased")
            
            let delete = purchasedTable.drop(ifExists: true)
            try db.run(delete)
            
            let id = Expression<Int64>("id")
            let lienNumber = Expression<Int>("lien_number")
            let county = Expression<String?>("county")
            let state = Expression<String>("state")
            let price = Expression<String>("price")
            let rate = Expression<String>("rate")
            let address = Expression<String>("address")
            let city = Expression<String>("city")
            let zipcode = Expression<String>("zipcode")
            
            try db.run(purchasedTable.create { t in
                t.column(id, primaryKey: true)
                t.column(lienNumber, unique: true)
                t.column(county)
                t.column(state)
                t.column(price)
                t.column(rate)
                t.column(address)
                t.column(city)
                t.column(zipcode)
            })
        } catch {
            print (error)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        createTaxLiensTable()
//        createPortfolioTable()
//        createPurchasedTable()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

