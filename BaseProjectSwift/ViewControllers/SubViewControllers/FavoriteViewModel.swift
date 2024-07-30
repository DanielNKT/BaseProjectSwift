//
//  FavoriteViewModel.swift
//  BaseProjectSwift
//
//  Created by Bé Gạo on 7/4/24.
//

import Foundation
import RxSwift
import RxCocoa

class FavoriteViewModel: BaseViewModel {
    let url = URL(string: "https://jsonnplaceholder.typicode.com/users")
    let userSubject = PublishSubject<[User]>()
    let errorSubject = PublishSubject<APIError>()
    
    //MARK: Fetch User using async await
    func fetchUsers() {
        Task {
            let result = await self.fetchUsers()
            switch result {
            case .success(let users):
                self.userSubject.onNext(users)
            case .failure(let error):
                self.errorSubject.onNext(error)
            }
        }
    }
    
    private func fetchUsers() async -> Result<[User], APIError> {
        print("fetchUser")
        guard let url = url else { return .failure(.invalidUrl) }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                return .failure(.unexpected)
            }
            let users = try JSONDecoder().decode([User].self, from: data)
            return .success(users)
        } catch {
            return .failure(.unexpected)
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
    
    private func fetchUserUsingClosure(completion: @escaping (Result<[User], APIError>) -> Void) {
        print("fetchUser")
        guard let url = url else { return completion(.failure(.invalidUrl)) }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data, error == nil else {
                if let error = error as? URLError {
                    print("error: \(error.code)")
                }
                
                return completion(.failure(.unexpected))
            }
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                return completion(.success(users))
            } catch {
                return completion(.failure(.invalidJSON))
            }
            
        }.resume()
    }
}
