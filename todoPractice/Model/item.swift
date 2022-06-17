//
//  item.swift
//  todoPractice
//
//  Created by user on 2022/06/05.
//

import Foundation


struct Item:Codable {
    let weather: String
    let city: String
    let temperature: String
}

extension Item : Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool{
        return lhs.weather == rhs.weather && lhs.city == rhs.city && lhs.temperature == rhs.temperature
    }
}

