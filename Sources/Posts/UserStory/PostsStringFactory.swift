//
//  File.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//

import Foundation


struct PostsStringFactory: PostsListStringFactoryProtocol {
    var createPostTitle: String = "Поделитесь, что у Вас нового"
    var allPostsTitle: String = "Лента"
    var userPostsTitle: String = "Посты"
    var currentUserPostsTitle: String = "Ваши посты"
    var mainEmptyTitle: String = "Постов пока нет"
    var currentUserEmptyTitle: String = "Вы не добавили ниодного поста"
    var userEmptyTitle: String = "У этого пользователя пока нет постов"
}
