//
//  Strings.swift
//  LienFund
//
//  Created by Brando Flores on 1/2/22.
//

import Foundation

struct Strings {
    static let DBPath = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true).first
    static let NCPortfolioChanged = "PortfolioChanged"
    static let NCPortfolioPurchaseCompleted = "PortfolioPurchaseCompleted"
}
