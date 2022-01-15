//
//  PurchasedTable.swift
//  LienFund
//
//  Created by Brando Flores on 1/2/22.
//

import Foundation
import SQLite

struct PurchasedTable {
    let path = Strings.DBPath
    var dbConnection: Connection?
    var portfolioTable = Table("purchased")
    let idCol = Expression<Int64>("id")
    let lienNumberCol = Expression<Int>("lien_number")
    let countyCol = Expression<String?>("county")
    let stateCol = Expression<String>("state")
    let priceCol = Expression<String>("price")
    let rateCol = Expression<String>("rate")
    let addressCol = Expression<String>("address")
    let cityCol = Expression<String>("city")
    let zipcodeCol = Expression<String>("zipcode")
    
    init() {
        do {
            dbConnection = try Connection("\(path ?? "")/db.sqlite3")
        } catch {
            print(error)
        }
    }
    
    func AddLien(taxLien: TaxLien) -> Int {
        do {
            let p = String(format: "%f", taxLien.price)
            let r = String(format: "%f", taxLien.rate)
            let lien = self.portfolioTable.insert(lienNumberCol <- taxLien.number, countyCol <- taxLien.county, stateCol <- taxLien.state, priceCol <- p, rateCol <- r, addressCol <- taxLien.address, cityCol <- taxLien.city, zipcodeCol <- taxLien.zipcode)
            try dbConnection!.run(lien)
            return 0
        } catch {
            print(error)
            return -1
        }
    }
    
    func DeleteLien(taxLien: TaxLien) -> Int {
        do {
            try dbConnection!.run(self.portfolioTable.filter(lienNumberCol == taxLien.number).delete())
            return 0
        } catch {
            print(error)
            return -1
        }
    }
}
