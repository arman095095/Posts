//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation
import NetworkServices
import ModelInterfaces
import FirebaseFirestore

protocol ProfileInfoNetworkServiceProtocol {
    func getProfileInfo(userID: String, completion: @escaping (Result<ProfileNetworkModelProtocol,Error>) -> ())
}

final class ProfileInfoNetworkService {
    
    private let networkServiceRef: Firestore
    
    private var usersRef: CollectionReference {
        return networkServiceRef.collection(ProfileURLComponents.Paths.users.rawValue)
    }
    
    init(networkService: Firestore) {
        self.networkServiceRef = networkService
    }
}

extension ProfileInfoNetworkService: ProfileInfoNetworkServiceProtocol {
    
    func getProfileInfo(userID: String, completion: @escaping (Result<ProfileNetworkModelProtocol,Error>) -> ()) {
        usersRef.document(userID).getDocument { [weak self] (documentSnapshot, error) in
            if let error = error  {
                completion(.failure(error))
                return
            }
            if let dict = documentSnapshot?.data() {
                if var muser = ProfileNetworkModel(dict: dict) {
                    self?.getProfilePostsCount(userID: userID) { (result) in
                        switch result {
                        case .success(let count):
                            muser.postsCount = count
                            completion(.success(muser))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(GetUserInfoError.convertData))
                }
            } else {
                completion(.failure(GetUserInfoError.getData))
            }
        }
    }
}

private extension ProfileInfoNetworkService {
    func getProfilePostsCount(userID: String, completion: @escaping (Result<Int,Error>) -> ()) {
        usersRef.document(userID).collection(ProfileURLComponents.Paths.posts.rawValue).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let querySnapshot = querySnapshot else { return }
            let count = querySnapshot.count
            completion(.success(count))
        }
    }
}
