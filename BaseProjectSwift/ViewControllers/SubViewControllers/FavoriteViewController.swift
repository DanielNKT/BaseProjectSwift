//
//  FavoriteViewController.swift
//  BaseProjectSwift
//
//  Created by Bé Gạo on 7/4/24.
//

import Foundation
import UIKit
import RxSwift

class FavoriteViewController: BaseViewController, BindableType {
    var viewModel: FavoriteViewModel!
    
    let bag = DisposeBag()
    
    private lazy var label = UILabel().style {
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var tableView = UITableView().style {
        $0.backgroundColor = .clear
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
    }
    
    override func initUI() {
        super.initUI()
        
        self.view.addSubview(tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(label)
        tableView.constraintsTo(view: self.view, positions: .full)
        
        label.constraintsTo(view: self.view, positions: .left)
        label.constraintsTo(view: self.view, positions: .right)
        label.constraintsTo(view: self.view, positions: .centerY)
    }
    
    override func binding() {
        super.binding()
        
        viewModel.fetchUsers()
        
        viewModel.errorSubject.subscribe { element in
            self.reloadData(users: [], error: element)
        }.disposed(by: bag)
        
        viewModel.userSubject.subscribe { element in
            self.reloadData(users: element)
        }.disposed(by: bag)
    }
    
    private func reloadData(users: [User], error: CustomError = .failToGetData("")) {
        self.users = users
        DispatchQueue.main.async {
            if users.isEmpty {
                self.tableView.isHidden = true
                self.label.isHidden = false
                switch error {
                case let .failToGetData(reason):
                    self.label.text = reason
                }
            } else {
                self.tableView.isHidden = false
                self.label.isHidden = true
            }
            
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        cell.backgroundColor = .clear
        return cell
    }
}
