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
    
    private var predefinedDataSource = Set<Film>()

    func saveDataSource(dataSource: Set<Film>) {
        let data = try? PropertyListEncoder().encode(dataSource)
        userDefaults.set(data, forKey: key)
    }
    
    func readDataSource() -> Set<Film> {
        guard
            let dataArray = userDefaults.value(forKey: key) as? Data,
            let decodedArray = try? PropertyListDecoder().decode(Set<Film>.self, from: dataArray)
        else {
            return predefinedDataSource
        }
        return decodedArray
    }
}
