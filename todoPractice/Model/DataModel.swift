//
//  Data.swift
//  todoPractice
//
//  Created by user on 2022/06/11.
//

import Foundation


struct DataModel {
    let dataFilePath:URL?

    init(userId:String){
        dataFilePath =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(userId)Items.plist")
    }
    
    func saveData (_ itemArray:[Item]) {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: self.dataFilePath!)
        }catch{
            print("error")
        }
    }
    
    func loadData() -> [Item] {
        var itemArray: [Item]?
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                try itemArray = decoder.decode([Item].self, from: data)
            }catch{
                print("error")
            }

        }
        return itemArray ?? [Item]()
    }
}
