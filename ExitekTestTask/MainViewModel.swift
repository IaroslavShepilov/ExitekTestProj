//
//  MainViewModel.swift
//  ExitekTestTask
//
//  Created by Yaroslav Shepilov on 31.08.2022.
//

import Foundation

final class MainViewModel {

    var delegate: MainViewController?
    private let localDataSource = LocalDataSource()
    var dataSource: [Films]

    init() {
        self.dataSource = localDataSource.readDataSource()
    }
    
    func createFilm(title: String, year: Int) {
        let film = Films(title: title, year: year)
        dataSource.append(film)
        save()
        delegate?.tableView.reloadData()
    }
    
    func deleteFilm(indexPath: Int) {
        dataSource.remove(at: indexPath)
        save()
        delegate?.tableView.reloadData()
    }
    
    func setupAddButton() {
        guard let title = delegate?.titleTextField.text, let yearString = delegate?.yearTextField.text,  let year = Int(yearString) else {
            delegate?.showAlertForEmptyField()
            return
        }
        if title.isEmpty == false && yearString.isEmpty == false {
            if dataSource.contains(where: { $0.title == title }) != (delegate?.titleTextField.text != nil) {
                createFilm(title: title, year: year)
        } else {
            delegate?.showAlertForDuplicatedMovie()
            }
        } else {
            delegate?.showAlertForEmptyField()
        }
        delegate?.tableView.reloadData()
    }
    
    func save() {
       localDataSource.saveDataSource(dataSource: dataSource)
    }
}

struct Films : Equatable, Codable {
    let title: String
    let year: Int
}
