//
//  ViewController.swift
//  BaseProjectSwift
//
//  Created by Nguyen Toan on 3/16/21.
//
import UIKit
import RxSwift

class HomeViewController: BaseViewController, BindableType, UITableViewDataSource, UITableViewDelegate {
    
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
    private lazy var segmentedControlContainerView = UIView().style {
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var segmentedControl = CustomSegmentedControl().style {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var viewModel: HomeViewModel!
    
    private var users = [User]()
    
    override func initUI() {
        super.initUI()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.addSubview(tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(label)
        
        view.addSubview(segmentedControlContainerView)
        segmentedControlContainerView.addSubview(segmentedControl)
        
        setConstraints()
        viewModel.fetchUsers()
    }
    
    override func binding() {
        super.binding()
        
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
    fileprivate func setConstraints() {
        segmentedControlContainerView.constraintsTo(view: self.view, positions: .top)
        segmentedControlContainerView.constraintsTo(view: self.view, positions: .left)
        segmentedControlContainerView.constraintsTo(view: self.view, positions: .right)
        
        tableView.constraintsTo(view: self.view, positions: .left)
        tableView.constraintsTo(view: self.view, positions: .right)
        tableView.constraintsTo(view: self.view, positions: .bottom)
        tableView.constraintsTo(view: self.segmentedControlContainerView, positions: .below)
        
        segmentedControl.constraintsTo(view: segmentedControlContainerView)
        segmentedControl.heightItem(Constants.Segment.segmentedControlHeight)
        label.constraintsTo(view: self.view, positions: .left)
        label.constraintsTo(view: self.view, positions: .right)
        label.constraintsTo(view: self.view, positions: .centerY)
    }
    
    
}

extension HomeViewController {
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


