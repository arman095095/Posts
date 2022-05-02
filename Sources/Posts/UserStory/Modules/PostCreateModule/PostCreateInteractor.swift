//
//  PostCreateInteractor.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol PostCreateInteractorInput: AnyObject {
    
}

protocol PostCreateInteractorOutput: AnyObject {
    
}

final class PostCreateInteractor {
    
    weak var output: PostCreateInteractorOutput?
}

extension PostCreateInteractor: PostCreateInteractorInput {
   
}
