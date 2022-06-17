//
//  WeatherData.swift
//  todoPractice
//
//  Created by user on 2022/06/12.
//

import Foundation


struct WeatherData: Codable {
    let name:String
    let main:Main
    let weather:[Weather]
    
}

struct Main: Codable {
    let temp:Double
}

struct Weather: Codable {
    let id:Int
    let description:String
}
