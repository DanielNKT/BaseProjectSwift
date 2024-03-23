//
//  ViewController.swift
//  BaseProjectSwift
//
//  Created by Nguyen Toan on 3/16/21.
//
import UIKit

class HomeViewController: BaseViewController, BindableType, UITableViewDataSource, UITableViewDelegate {
    
    private lazy var tableView = UITableView().style {
        $0.backgroundColor = .clear
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var segmentedControlContainerView = UIView().style {
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var segmentedControl = CustomSegmentedControl(frame: .zero).style {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var viewModel: HomeViewModel!
    
    private var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initUI() {
        super.initUI()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.addSubview(tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        view.addSubview(segmentedControlContainerView)
        segmentedControlContainerView.addSubview(segmentedControl)
        
        setConstraints()
        fetchUsers()
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
    }
    
    //MARK: Fetch User using async await
    private func fetchUsers() {
        Task {
            let result = await viewModel.fetchUsers()
            switch result {
            case .success(let users):
                self.users = users
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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


