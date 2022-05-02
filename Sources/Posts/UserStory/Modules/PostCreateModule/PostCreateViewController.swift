//
//  PostCreateViewController.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PostCreateViewInput: AnyObject {
    
}

final class PostCreateViewController: UIViewController {
    var output: PostCreateViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension PostCreateViewController: PostCreateViewInput {
    
}
