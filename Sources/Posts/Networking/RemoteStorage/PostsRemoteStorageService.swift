//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import Foundation
import NetworkServices
import FirebaseStorage

protocol PostsRemoteStorageServiceProtocol {
    func uploadPost(image: Data, completion: @escaping (Result<String, Error>) -> Void)
}

final class PostsRemoteStorageService {

    private let storage: Storage
    
    private var postsImagesRef: StorageReference {
        storage.reference().child(StorageURLComponents.Paths.posts.rawValue)
    }
    
    init(storage: Storage) {
        self.storage = storage
    }
}

extension PostsRemoteStorageService: PostsRemoteStorageServiceProtocol {
    
    public func uploadPost(image: Data, completion: @escaping (Result<String, Error>) -> Void) {
        let metadata = StorageMetadata()
        let imageName = UUID().uuidString
        metadata.contentType = StorageURLComponents.Parameters.imageJpeg.rawValue
        postsImagesRef.child(imageName).putData(image, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            self.postsImagesRef.child(imageName).downloadURL { (url, error) in
                guard let downloadURL = url else { return }
                completion(.success(downloadURL.absoluteString))
            }
        }
    }
}
