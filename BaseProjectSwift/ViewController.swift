//
//  ViewController.swift
//  BaseProjectSwift
//
//  Created by Nguyen Toan on 3/16/21.
//
import UIKit

struct User: Codable {
    let name: String
}

enum CustomError: Error {
    case failToGetData(String)
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var tableView: UITableView = {
        var tableView  = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var segmentedControlContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private lazy var segmentedControl: CustomSegmentedControl = {
        let segmentedControl = CustomSegmentedControl(frame: .zero)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private var users = [User]()
    let url = URL(string: "https://jsonplaceholder.typicode.com/users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchUsers()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        self.tableView.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.addSubview(tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        view.addSubview(segmentedControlContainerView)
        segmentedControlContainerView.addSubview(segmentedControl)
        
        setConstraints()
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Test Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        let numbers = [0]
        let _ = numbers[1]
    }
    fileprivate func setConstraints() {
        segmentedControlContainerView.constraintsTo(view: self.view, positions: .top)
        segmentedControlContainerView.constraintsTo(view: self.view, positions: .left)
        segmentedControlContainerView.constraintsTo(view: self.view, positions: .right)
        segmentedControlContainerView.heightItem(Constants.Segment.segmentedControlHeight)
        
        tableView.constraintsTo(view: self.view, positions: .left)
        tableView.constraintsTo(view: self.view, positions: .right)
        tableView.constraintsTo(view: self.view, positions: .bottom)
        tableView.constraintsTo(view: self.segmentedControlContainerView, positions: .below)
        
        segmentedControl.constraintsTo(view: segmentedControlContainerView)
    }
    
    //MARK: Fetch User using async await
    private func fetchUsers() {
        Task {
            let result = await fetchUsers()
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
    
    private func fetchUsers() async -> Result<[User], CustomError> {
        print("fetchUser")
        guard let url = url else { return .failure(.failToGetData("Url is not valid")) }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                return .failure(.failToGetData("Error while fetching data"))
            }
            let users = try JSONDecoder().decode([User].self, from: data)
            return .success(users)
        } catch {
            return .failure(.failToGetData(error.localizedDescription))
        }
    }
    //MARK: Fetch User using closure
    private func fetchUserUsingClosure() {
        fetchUserUsingClosure { [weak self] result in
            guard let self = self else { return }
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
    
    private func fetchUserUsingClosure(completion: @escaping (Result<[User], CustomError>) -> Void) {
        print("fetchUser")
        guard let url = url else { return completion(.failure(.failToGetData("Url is not valid"))) }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                return completion(.failure(.failToGetData("Url is not valid")))
            }
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                return completion(.success(users))
            } catch {
                return completion(.failure(.failToGetData(error.localizedDescription)))
            }
            
        }.resume()
    }
}

extension ViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
}


