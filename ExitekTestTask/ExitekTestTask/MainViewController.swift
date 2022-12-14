//
//  MainViewController.swift
//  ExitekTestTask
//
//  Created by Yaroslav Shepilov on 31.08.2022.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private var titleTextField: UITextField!
    @IBOutlet private var yearTextField: UITextField!
    @IBOutlet private var addButton: UIButton!
    @IBOutlet private var tableView: UITableView!
    
    var model = MainViewModel(localDataSource: LocalDataSource())

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @objc func didTapAddButton() {
        let index = model.dataSource.count
        model.setupAddButton(title: titleTextField.text, year: yearTextField.text, position: index)
        titleTextField.text = nil
        yearTextField.text = nil
        titleTextField.resignFirstResponder()
        yearTextField.resignFirstResponder()
    }

    // MARK: - SetupTableView-
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        }
        cell?.textLabel?.text = model.dataSource[indexPath.row].title + ", " + "\(model.dataSource[indexPath.row].year)"
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let film = model.dataSource[indexPath.row]
            model.deleteFilm(film)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func setup() {
        titleTextField.delegate = self
        yearTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        model.delegate = self
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    }
}

extension MainViewController: MainViewModelProtocol {
    
    func showAlertForDuplicatedMovie() {
        let alert = UIAlertController(title: nil, message: "You have already added this movie to your favorites! ??hoose another movie and try again.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    func addRow(at indexPath: [IndexPath]) {
        tableView.insertRows(at: indexPath, with: .top)
    }
        
    func showAlertForEmptyField() {
        let alert = UIAlertController(title: nil, message: "Movie name or release year not specified", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}
