//
//  LocalDataSource.swift
//  ExitekTestTask
//
//  Created by Yaroslav Shepilov on 31.08.2022.
//
import Foundation

struct LocalDataSource {
    private let userDefaults = UserDefaults.standard
    private let key = "storedDataSourceKey"
    
    private var predefinedDataSource = [
        Films(title: "Titanic", year: 1997),
        Films(title: "Inception", year: 2010),
        Films(title: "Borat", year: 2006),
        Films(title: "The Silence of the Lambs", year: 1991),
        Films(title: "Batman", year: 2022)
        ]

    func saveDataSource(dataSource: [Films]) {
        let data = try? PropertyListEncoder().encode(dataSource)
        userDefaults.set(data, forKey: key)
    }
    
    func readDataSource() -> [Films] {
        guard
            let dataArray = userDefaults.value(forKey: key) as? Data,
            let decodedArray = try? PropertyListDecoder().decode([Films].self, from: dataArray)
        else {
            return predefinedDataSource
        }
        return decodedArray
    }
}
