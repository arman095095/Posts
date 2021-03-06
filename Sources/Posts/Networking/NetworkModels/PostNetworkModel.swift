//
//  File.swift
//  
//
//  Created by Арман Чархчян on 20.05.2022.
//

import NetworkServices
import UIKit
import FirebaseFirestore

public protocol PostNetworkModelProtocol: AnyObject {
    var userID: String { get set }
    var likersIds: [String] { get set }
    var date: Date { get set }
    var id: String { get set }
    var textContent: String { get set }
    var urlImage: String? { get set }
    var imageHeight: CGFloat? { get set }
    var imageWidth: CGFloat? { get set }
    
    func convertModelToDictionary() -> [String: Any]
}

public final class PostNetworkModel: PostNetworkModelProtocol {
    
    public var userID: String
    public var likersIds: [String]
    public var date: Date
    public var id: String
    public var textContent: String
    public var urlImage: String?
    public var imageHeight: CGFloat?
    public var imageWidth: CGFloat?
    
    public init(userID: String,
                textContent: String,
                urlImage: String?,
                imageHeight: CGFloat?,
                imageWidth: CGFloat?) {
        self.userID = userID
        self.id = UUID().uuidString
        self.textContent = textContent
        self.urlImage = urlImage
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.likersIds = []
        self.date = Date()
    }
    
    init?(postDictionary: [String:Any]) {
        guard let id = postDictionary[PostsURLComponents.Parameters.id.rawValue] as? String,
              let date = postDictionary[PostsURLComponents.Parameters.date.rawValue] as? Timestamp,
              let textContent = postDictionary[PostsURLComponents.Parameters.textContent.rawValue] as? String,
              let userID = postDictionary[PostsURLComponents.Parameters.userID.rawValue] as? String
        else { return nil }
        
        self.userID = userID
        self.id = id
        self.textContent = textContent
        self.date = date.dateValue()
        self.likersIds = []
        
        if let urlImage = postDictionary[PostsURLComponents.Parameters.urlImage.rawValue] as? String {
            self.urlImage = urlImage
        }
        if let imageHeight = postDictionary[PostsURLComponents.Parameters.imageHeight.rawValue] as? CGFloat,
           let imageWidth = postDictionary[PostsURLComponents.Parameters.imageWidth.rawValue] as? CGFloat {
            self.imageHeight = imageHeight
            self.imageWidth = imageWidth
        }
    }
    
    convenience init?(queryDocumentSnapshot: QueryDocumentSnapshot) {
        let postDictionary = queryDocumentSnapshot.data()
        self.init(postDictionary: postDictionary)
    }
    
    convenience init?(documentSnapshot: DocumentSnapshot) {
        guard let postDictionary = documentSnapshot.data() else { return nil }
        self.init(postDictionary: postDictionary)
    }
    
    public func convertModelToDictionary() -> [String: Any] {
        var postDictionary: [String:Any] = [PostsURLComponents.Parameters.userID.rawValue: userID]
        postDictionary[PostsURLComponents.Parameters.id.rawValue] = id
        postDictionary[PostsURLComponents.Parameters.textContent.rawValue] = textContent
        postDictionary[PostsURLComponents.Parameters.date.rawValue] = FieldValue.serverTimestamp()
        
        if let urlImage = self.urlImage {
            postDictionary[PostsURLComponents.Parameters.urlImage.rawValue] = urlImage
        }
        if let imageHeight = self.imageHeight,
           let imageWidth = self.imageWidth {
            postDictionary[PostsURLComponents.Parameters.imageHeight.rawValue] = imageHeight
            postDictionary[PostsURLComponents.Parameters.imageWidth.rawValue] = imageWidth
        }
        return postDictionary
    }
}
