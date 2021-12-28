//
//  Businesses.swift
//  Shuffle
//
//  Created by Mohammad Mahmud on 4/28/21.
//
import Foundation


// MARK: - Welcome
struct Response: Codable {
    let businesses: [Business]
}

// MARK: - Business
struct Business: Codable {
    let rating: Double
    let price: String?
    let phone, id, alias: String
    let categories: [Category]
    let name: String
    let coordinates: Center
    let image_url: String
    let location: Location
    let distance: Double
    let transactions: [String]
}

// MARK: - Category
struct Category: Codable {
    let alias, title: String
}

// MARK: - Center
struct Center: Codable {
    let latitude, longitude: Double
}

// MARK: - Location
struct Location: Codable {
    var city = ""
    var state = ""
    var address1 = String()
    var zip_code = ""
}



