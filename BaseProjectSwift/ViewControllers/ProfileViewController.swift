//
//  ProfileViewController.swift
//  BaseProjectSwift
//
//  Created by Nguyen Khanh Toan on 29/03/2024.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileViewController: BaseViewController, BindableType {
    var viewModel: ProfileViewModel!
    
    private var cities = ["Hà Nội","Hải Phòng", "Vinh", "Huế", "Đà Nẵng", "Nha Trang", "Đà Lạt", "Vũng Tàu", "Hồ Chí Minh", "Logout"]
    
    let bag = DisposeBag()
    
    private lazy var tableView = UITableView().style {
        $0.backgroundColor = .clear
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell2")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func initUI() {
        super.initUI()
        self.view.backgroundColor = .clear
        
        self.view.addSubview(tableView)
        
        tableView.constraintsTo(view: self.view, positions: .left)
        tableView.constraintsTo(view: self.view, positions: .right)
        tableView.constraintsTo(view: self.view, positions: .bottom)
        tableView.constraintsTo(view: self.view, positions: .top)
        
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(settingTap))


        setupTableview()
    }
    
    @objc func settingTap() {
        print("setting tapped")
    }
    private func setupTableview(){
        // create observable
        let observable = Observable.of(cities)
        // bind to tableview
        //        observable
        //            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (index, element, cell) in
        //                cell.textLabel?.text = element
        //                cell.backgroundColor = .clear
        //            }
        //            .disposed(by: bag)
        
        observable.bind(to: tableView.rx.items) { (tableView, index, element) in
            let indexPath = IndexPath(row: index, section: 0)
            if index % 2 == 0 {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "cell1")
                cell.textLabel?.text = element
                cell.backgroundColor = .yellow
                return cell
            } else {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "cell2")
                cell.textLabel?.text = element
                cell.backgroundColor = .blue
                return cell
            }
        }
        .disposed(by: bag)
        
        // selected cell
        tableView.rx
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
        tableView.rx
            .itemDeselected
            .subscribe(onNext: { indexPath in
                print("Deselected with indextPath: \(indexPath)")
            })
            .disposed(by: bag)
    }
}
