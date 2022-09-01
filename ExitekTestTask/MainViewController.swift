//
//  MainViewController.swift
//  ExitekTestTask
//
//  Created by Yaroslav Shepilov on 31.08.2022.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let model = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        yearTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        model.delegate = self
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
    }
    
    @objc func didTapAddButton() {
        model.setupAddButton(title: titleTextField.text ?? "", year: yearTextField.text ?? "")
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
            model.deleteFilm(indexPath: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
}

extension MainViewController: MainViewModelProtocol {
    func showAlertForDuplicatedMovie() {
        let alert = UIAlertController(title: nil, message: "You have already added this movie to your favorites! Сhoose another movie and try again.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    func showAlertForEmptyField() {
        let alert = UIAlertController(title: nil, message: "Movie name or release year not specified", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}
