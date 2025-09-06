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
    
    private lazy var tableViewUsingRx = UITableView().style {
        $0.backgroundColor = .clear
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell1")
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell2")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = true
    }
    
    private lazy var searchBar = UISearchBar().style {
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundImage = UIImage()
    }
    private lazy var segmentedControlContainerView = UIView().style {
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var segmentedControl = CustomSegmentedControl(segmentItems: ["World", "VietNam"]).style {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let filteredVNCities = BehaviorRelay<[String]>(value: [])
    private var cities = ["Hà Nội","Hải Phòng", "Vinh", "Huế", "Đà Nẵng", "Nha Trang", "Đà Lạt", "Vũng Tàu", "Hồ Chí Minh", "Vinh"]
    
    var shownCities = [String]() // Data source for UITableView
    let allCities = ["Oklahoma", "Chicago", "Moscow", "Danang", "Vancouver", "Praga"] // Mocked API data source
    
    private let isSearchVNCities = BehaviorRelay<Bool>(value: false)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func initUI() {
        super.initUI()
        self.view.backgroundColor = .clear
        
        self.view.addSubview(searchBar)
        view.addSubview(segmentedControlContainerView)
        segmentedControlContainerView.addSubview(segmentedControl)
        self.view.addSubview(tableView)
        self.view.addSubview(tableViewUsingRx)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        segmentedControlContainerView.constraintsTo(view: self.view, positions: .top)
        segmentedControlContainerView.constraintsTo(view: self.view, positions: .left)
        segmentedControlContainerView.constraintsTo(view: self.view, positions: .right)
        
        segmentedControl.constraintsTo(view: segmentedControlContainerView)
        segmentedControl.heightItem(Constants.Segment.segmentedControlHeight)
        
        searchBar.constraintsTo(view: self.view, positions: .left)
        searchBar.constraintsTo(view: self.view, positions: .right)
        //        searchBar.constraintsTo(view: self.view, positions: .top)
        searchBar.constraintsTo(view: self.segmentedControlContainerView, positions: .topToBottom)
        
        tableView.constraintsTo(view: self.view, positions: .left)
        tableView.constraintsTo(view: self.view, positions: .right)
        tableView.constraintsTo(view: self.view, positions: .bottom)
        tableView.constraintsTo(view: searchBar, positions: .below)
        
        tableViewUsingRx.constraintsTo(view: self.view, positions: .left)
        tableViewUsingRx.constraintsTo(view: self.view, positions: .right)
        tableViewUsingRx.constraintsTo(view: self.view, positions: .bottom)
        tableViewUsingRx.constraintsTo(view: searchBar, positions: .below)
    }
    
    override func binding() {
        super.binding()
        
        searchBar
            .rx.text // Observable property
            .orEmpty // Make it non-optional
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance) // Wait 0.5 for changes.
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] query in
                if self.isSearchVNCities.value {
                    let filtered = self.cities.filter { $0.localizedStandardContains(query) }
                    self.filteredVNCities.accept(filtered)
                } else {
                    self.shownCities = self.allCities.filter { $0.localizedStandardContains(query) } // We now do our "API Request" to find cities.
                    print("\(shownCities)")
                    self.tableView.reloadData() // And reload table view data.
                }
                
            })
            .disposed(by: bag)
        
        setupTableview()
    }
    
    private func setupTableview(){
        // create observable
        filteredVNCities.accept(cities)
        filteredVNCities
            .asObservable()
            .bind(to: tableViewUsingRx.rx.items) { (tableView, index, element) in
                if index % 2 == 0 {
                    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell1")
                    cell.textLabel?.text = element
                    cell.textLabel?.textColor = .black
                    cell.backgroundColor = .clear
                    return cell
                } else {
                    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell2")
                    cell.textLabel?.text = element
                    cell.textLabel?.textColor = .black
                    cell.backgroundColor = .clear
                    return cell
                }
            }
            .disposed(by: bag)
        
        // selected cell
        tableViewUsingRx.rx
            .modelSelected(String.self)
            .subscribe(onNext: { element in
                print("Selected \(element)")
                if self.cities.last == element {
                    print("press last item")
                    let vc = SignInViewController().bind(SignInViewModel())
                    let navigationController = UINavigationController(rootViewController: vc)
                    AppDelegate.shared.window?.rootViewController = navigationController
                }
            })
            .disposed(by: bag)
        
        // de-selected index
        tableViewUsingRx.rx
            .itemDeselected
            .subscribe(onNext: { indexPath in
                print("Deselected with indextPath: \(indexPath)")
            })
            .disposed(by: bag)
        
        isSearchVNCities
            .asDriver()
            .drive(onNext: { [weak self] isVN in
                self?.tableView.isHidden = isVN
                self?.tableViewUsingRx.isHidden = !isVN
            })
            .disposed(by: bag)
        
        segmentedControl.delegate = self
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
        cell.textLabel?.textColor = .black
        cell.backgroundColor = .clear
        return cell
    }
}

extension LocationViewController: CustomSegmentedControlDelegate {
    func didSelectIndex(index: Int) {
        DispatchQueue.main.async {
            self.isSearchVNCities.accept(index != 0)
        }
    }
}
