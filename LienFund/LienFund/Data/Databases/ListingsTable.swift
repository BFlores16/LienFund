//
//  ListingsTable.swift
//  LienFund
//
//  Created by Brando Flores on 1/2/22.
//

import Foundation
import SQLite

struct ListingsTable {
    let path = Strings.DBPath
    var dbConnection: Connection?
    let taxLiensTable = Table("tax_liens")
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
    
    func GetTaxLiens() -> [TaxLien] {
        var taxLiens = [TaxLien]()
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        do {
            for lien in try dbConnection!.prepare(self.taxLiensTable) {
                let p = Double(lien[priceCol])!
                let r = Double(lien[rateCol]) ?? 0.0
                taxLiens.append(TaxLien(number: lien[lienNumberCol], county: lien[countyCol] ?? "", state: lien[stateCol], price: p, rate: r, address: lien[addressCol], city: lien[cityCol], zipcode: lien[zipcodeCol]))
            }
        } catch {
            print (error)
        }
        return taxLiens
    }
    
    func AddLien(taxLien: TaxLien) -> Int {
        do {
            let p = String(format: "%f", taxLien.price)
            let r = String(format: "%f", taxLien.rate)
            let lien = taxLiensTable.insert(lienNumberCol <- taxLien.number, countyCol <- taxLien.county, stateCol <- taxLien.state, priceCol <- p, rateCol <- r, addressCol <- taxLien.address, cityCol <- taxLien.city, zipcodeCol <- taxLien.zipcode)
            try dbConnection!.run(lien)
            return 0
        } catch {
            print(error)
            return -1
        }
    }
    
    func DeleteLien(taxLien: TaxLien) -> Int {
        do {
            try dbConnection!.run(taxLiensTable.filter(lienNumberCol == taxLien.number).delete())
            return 0
        } catch {
            print(error)
            return -1
        }
    }
}
