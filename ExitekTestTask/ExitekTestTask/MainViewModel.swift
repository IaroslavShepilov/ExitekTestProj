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
    func addRow(at indexPath: [IndexPath])
}

final class MainViewModel {

    var delegate: MainViewModelProtocol?
    var dataSource: [Film]

    private let localDataSource: LocalDataSource
    private var dataSet: Set<Film>

    init(localDataSource: LocalDataSource) {
        self.localDataSource = localDataSource
        self.dataSet = localDataSource.readDataSource()
        self.dataSource = Array(dataSet)
        handleSet()
    }
    
    func createFilm(title: String, year: Int, position: Int) {
        let film = Film(title: title, year: year, position: position)
        if dataSet.contains(film) {
            delegate?.showAlertForDuplicatedMovie()
        } else {
            dataSet.insert(film)
            handleSet()
            delegate?.addRow(at: [IndexPath(row: position, section: 0)])
        }
    }
    
    func deleteFilm(_ film: Film) {
        if dataSet.contains(film) {
            dataSet.remove(film)
            handleSet()
        }
    }
     
    func setupAddButton(title: String?, year: String?, position: Int?) {
        guard let titleString = title, !titleString.isEmpty, let yearString = year,  let year = Int(yearString), let position = position else {
            delegate?.showAlertForEmptyField()
            return
        }
        createFilm(title: titleString.trimmingCharacters(in: .whitespaces), year: year, position: position)
    }
    
    private func handleSet() {
        let sorted = Array(dataSet).sorted { firstFilm, secondFilm -> Bool in
            firstFilm.position < secondFilm.position
        }
        dataSource = sorted
        save()
    }
    
    func save() {
       localDataSource.saveDataSource(dataSource: dataSet)
    }
}

struct Film {
    let title: String
    let year: Int
    let position: Int
}

extension Film: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(year)
    }
}

extension Film: Equatable, Codable {
    static func == (lhs: Film, rhs: Film) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

