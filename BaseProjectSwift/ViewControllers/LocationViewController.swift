//
//  LocationViewController.swift
//  BaseProjectSwift
//
//  Created by Nguyen Khanh Toan on 29/03/2024.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class LocationViewController: BaseViewController, BindableType {
    var viewModel: LocationViewModel!
    
    let bag = DisposeBag()
    
    private lazy var tableView = UITableView().style {
        $0.backgroundColor = .clear
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var searchBar = UISearchBar().style {
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundImage = UIImage()
    }
    
    var shownCities = [String]() // Data source for UITableView
    let allCities = ["Oklahoma", "Chicago", "Moscow", "Danang", "Vancouver", "Praga"] // Mocked API data source
    
    override func initUI() {
        super.initUI()
        self.view.backgroundColor = .clear
        
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.constraintsTo(view: self.view, positions: .left)
        searchBar.constraintsTo(view: self.view, positions: .right)
        searchBar.constraintsTo(view: self.view, positions: .top)
        tableView.constraintsTo(view: self.view, positions: .left)
        tableView.constraintsTo(view: self.view, positions: .right)
        tableView.constraintsTo(view: self.view, positions: .bottom)
        tableView.constraintsTo(view: searchBar, positions: .below)
    }
    
    override func binding() {
        super.binding()
        
        searchBar
            .rx.text // Observable property
            .orEmpty // Make it non-optional
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance) // Wait 0.5 for changes.
            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
            //.filter { !$0.isEmpty } // If the new value is really new, filter for non-empty query.
            .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value, that is not empty (thanks to filter above).
                self.shownCities = self.allCities.filter { $0.localizedStandardContains(query) } // We now do our "API Request" to find cities.
                self.tableView.reloadData() // And reload table view data.
            })
            .disposed(by: bag)
    }
}

extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let searchText = searchBar.searchTextField.text else {
            return allCities.count
        }
        return searchText.isEmpty ? allCities.count : shownCities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let searchText = searchBar.searchTextField.text {
            cell.textLabel?.text = searchText.isEmpty ? allCities[indexPath.row] : shownCities[indexPath.row]
        } else {
            cell.textLabel?.text = allCities[indexPath.row]
        }
        cell.backgroundColor = .clear
        return cell
    }
}
