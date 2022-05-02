//
//  PostsViewController.swift
//  diffibleData
//
//  Created by Arman Davidoff on 24.11.2020.
//  Copyright © 2020 Arman Davidoff. All rights reserved.
//
/*
import UIKit
import RxSwift

class PostsViewController: UIViewController {
    
    private let postsViewModel: PostsViewModel
    private var tableView: UITableView!
    private var dataSource: UITableViewDiffableDataSource<Sections,MPost>!
    private let dispose = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private let footer = FooterView()
    private let activityIndicator: CustomActivityIndicator = {
        let view = CustomActivityIndicator()
        view.strokeColor = UIColor.mainApp()
        view.lineWidth = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupActivity()
        setupDataSource()
        setupBinding()
        updatePosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        PostCellConstants.topBarHeight = topBarHeight
        PostCellConstants.bottonBarHeight = buttonBarHeight
        footer.stop()
        tabBarController?.tabBar.isHidden = postsViewModel.tabBarHidden
    }
    
    init(postsViewModel: PostsViewModel) {
        self.postsViewModel = postsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomHeight = postsViewModel.tabBarHidden ? 0 : buttonBarHeight
        let offsetY = tableView.contentOffset.y
        let contentHeight = tableView.contentSize.height - tableView.frame.size.height + tableView.contentInset.bottom + bottomHeight
        
        if offsetY >= contentHeight/2 && postsViewModel.allowMoreLoad && postsViewModel.postsCountOverLimit {
            footer.start()
            postsViewModel.loadMore()
        }
    }
}

//MARK: Setup Binding
private extension PostsViewController {
    
    func setupBinding() {
        postsViewModel.updatedPosts.asDriver().drive(onNext: { [weak self] updated in
            if updated {
                self?.complitionAfterUpdatingPosts()
                self?.reloadData()
            }
        }).disposed(by: dispose)
        
        postsViewModel.updatedNextPosts.asDriver().drive(onNext: { [weak self] (updated, info) in
            guard let updated = updated else { return }
            if updated {
                self?.complitionAfterUpdatingPosts()
                self?.reloadData()
            } else if let info = info {
                self?.footer.stop(info: info)
            }
        }).disposed(by: dispose)
        
        postsViewModel.sendingError.asDriver().drive(onNext: { [weak self] error in
            if let error = error {
                self?.complitionAfterUpdatingPosts()
                if let _ = error as? ConnectionError {
                    Alert.present(type: .connection)
                } else {
                    Alert.present(type: .error,title: error.localizedDescription)
                }
            }
        }).disposed(by: dispose)
    }
    
    func complitionAfterUpdatingPosts() {
        activityIndicator.completeLoading(success: true)
        activityIndicator.isHidden = true
        postsViewModel.allowMoreLoad = true
        footer.stop()
        if refreshControl.isRefreshing {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.refreshControl.endRefreshing()
            }
        }
        
    }
}




//MARK: PostCellDelegate
extension PostsViewController: PostCellDelegate {
    
    func likePost(cell: PostCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        postsViewModel.likePost(at: indexPath)
    }
    
    func openUserProfile(cell: PostCell) {
        if postsViewModel.allPosts {
            let postOwner = postsViewModel.postOwner(at: tableView.indexPath(for: cell))
            let vc = Builder.shared.profileVC(friend: postOwner, managers: postsViewModel.managers)
            present(vc, animated: true)
        } else if let _ = navigationController?.popViewController(animated: true) {
            return
        } else {
            navigationController?.dismiss(animated: true)
        }
    }
    
    func reloadCell(cell: PostCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let post = postsViewModel.showFullText(at: indexPath)
        reloadCell(post: post)
    }
    
    func presentOwnerAlert(cell: PostCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let alert = UIAlertController(title: "Вы уверены?", message: "Хотите удалить этот пост?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Удалить", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.deletePost(indexPath: indexPath)
        })
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func deletePost(indexPath: IndexPath) {
        let post = postsViewModel.post(at: indexPath)
        postsViewModel.deletePost(post: post)
        reloadDataWithDeletedPost(post: post)
        Alert.present(type: .success, title: "Пост удален")
    }
}
*/
