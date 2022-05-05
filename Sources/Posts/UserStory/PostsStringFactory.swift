//
//  File.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//

import Foundation


struct PostsStringFactory: PostsListStringFactoryProtocol,
                           PostCreateStringFactoryProtocol {
    var successCreatedPost: String = "Пост опубликован"
    var sendButtonImageName: String = "Sent"
    var textViewPlaceholderText: String = "Что у Вас нового"
    var removeButtonImageName: String = "Cancel"
    var createPostTitle: String = "Поделитесь, что у Вас нового"
    var allPostsTitle: String = "Лента"
    var userPostsTitle: String = "Посты"
    var currentUserPostsTitle: String = "Ваши посты"
    var mainEmptyTitle: String = "Постов пока нет"
    var currentUserEmptyTitle: String = "Вы не добавили ниодного поста"
    var userEmptyTitle: String = "У этого пользователя пока нет постов"
}
