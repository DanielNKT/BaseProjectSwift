//
//  HomeViewModel.swift
//  BaseProjectSwift
//
//  Created by Bé Gạo on 19/3/24.
//

import Foundation

struct User: Codable {
    let name: String
    var isOpen: Bool? = false
}

enum CustomError: Error {
    case failToGetData(String)
}

class BaseViewModel: NSObject {
    
}

class HomeViewModel: BaseViewModel {
    let url = URL(string: "https://jsonplaceholder.typicode.com/users")
    
    func fetchUsers() async -> Result<[User], CustomError> {
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
                print(users)
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
