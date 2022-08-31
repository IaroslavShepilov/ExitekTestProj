//
//  MainViewModel.swift
//  ExitekTestTask
//
//  Created by Yaroslav Shepilov on 31.08.2022.
//

import Foundation

protocol MainViewModelProtocol {
    func showAlertForEmptyField()
    func showAlertForDuplicatedMovie()
    func reloadTable()
}
final class MainViewModel {

    var delegate: MainViewModelProtocol?
    private let localDataSource = LocalDataSource()
    var dataSource: [Films]

    init() {
        self.dataSource = localDataSource.readDataSource()
    }
    
    func createFilm(title: String, year: Int) {
        let film = Films(title: title, year: year)
        dataSource.append(film)
        save()
        delegate?.reloadTable()
    }
    
    func deleteFilm(indexPath: Int) {
        dataSource.remove(at: indexPath)
        save()
        delegate?.reloadTable()
    }
    
    func setupAddButton(title: String?, year: String?) {
        guard let titleString = title, let yearString = year,  let year = Int(yearString) else {
            delegate?.showAlertForEmptyField()
            return
        }
        if titleString.isEmpty == false && yearString.isEmpty == false {
            if dataSource.contains(where: { $0.title == title }) != (title != nil) {
                createFilm(title: titleString, year: year)
        } else {
            delegate?.showAlertForDuplicatedMovie()
            }
        } else {
            delegate?.showAlertForEmptyField()
        }
        delegate?.reloadTable()
    }
    
    func save() {
       localDataSource.saveDataSource(dataSource: dataSource)
    }
}

struct Films : Equatable, Codable {
    let title: String
    let year: Int
}
