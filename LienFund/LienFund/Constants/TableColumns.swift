//
//  TableColumns.swift
//  LienFund
//
//  Created by Brando Flores on 12/30/21.
//

import Foundation
import SQLite

struct TableColumns {
    static let TaxLiensTableColumns:[String:Any] = [
    "id":Expression<Int64>("id"),
    "lienNumber":Expression<Int>("lien_number"),
    "county":Expression<String?>("county"),
    "state":Expression<String>("state"),
    "price":Expression<String>("price"),
    "rate":Expression<String>("rate"),
    "address":Expression<String>("address"),
    "city":Expression<String>("city"),
    "zipcode":Expression<String>("zipcode")
    ]
}
