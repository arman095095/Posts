//
//  PostsListViewController.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import DesignSystem

protocol PostsListViewInput: AnyObject {
    func setupInitialState()
    func setLoad(on: Bool)
    func setFooterLoad(on: Bool)
    func reloadData(posts: [PostCellViewModel])
    func reloadData(post: PostCellViewModel)
    func reloadData(with deletedPost: PostCellViewModel)
}

final class PostsListViewController: UIViewController {

    var output: PostsListViewOutput?
    private var tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let footer = FooterView()
    private let activityIndicator: CustomActivityIndicator = {
        let view = CustomActivityIndicator()
        view.strokeColor = UIColor.mainApp()
        view.lineWidth = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var dataSource: UITableViewDiffableDataSource<Sections, PostCellViewModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let output = output else { return }
        let bottomHeight = output.tabBarHidden ? 0 : buttonBarHeight
        let offsetY = tableView.contentOffset.y
        let contentHeight = tableView.contentSize.height - tableView.frame.size.height + tableView.contentInset.bottom + bottomHeight
        
        if offsetY >= contentHeight/2 {
            output.requestMorePosts()
        }
    }
    
}

extension PostsListViewController: PostsListViewInput {
    
    func setupInitialState() {
        setupNavigationBar()
        setupTableView()
        setupActivity()
        setupDataSource()
    }
    
    func setLoad(on: Bool) {
        DispatchQueue.main.async {
            if on {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startLoading()
            } else {
                self.activityIndicator.completeLoading(success: true)
                self.activityIndicator.isHidden = true
                if refreshControl.isRefreshing { refreshControl.endRefreshing() }
            }
        }
    }
    
    func setFooterLoad(on: Bool) {
        DispatchQueue.main.async {
            on ? self.footer.start() : self.footer.stop()
        }
    }
    
    func reloadData(posts: [PostCellViewModel]) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Sections, PostCellViewModel>()
            snapshot.appendSections([.posts,.empty])
            snapshot.appendItems(posts, toSection: .posts)
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    func reloadData(post: PostCellViewModel) {
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([post])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func reloadData(with deletedPost: PostCellViewModel) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([deletedPost])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

private extension PostsListViewController {
  
    func setupNavigationBar() {
        navigationItem.title = output?.title
        navigationController?.navigationBar.barTintColor = .systemGray6
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
        tableView.allowsSelection = false
        tableView.backgroundColor = .systemGray6
        tableView.tableFooterView = footer
        tableView.separatorStyle = .none
        tableView.contentInset.bottom = 10
        tableView.delegate = self
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.cellID)
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        refreshControl.tintColor = UIColor.mainApp()
    }
    
    func setupActivity() {
        tableView.addSubview(activityIndicator)
        activityIndicator.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIScreen.main.bounds.height/2).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.constraint(equalTo: CGSize(width: 40, height: 40))
    }
    
    func infoView() -> UIView {
        guard let output = output else { return UIView() }
        let view = EmptyHeaderView()
        view.config(type: .emptyPosts,
                    text: output.infoTitleText)
        return view
    }
    
    func postTitleView() -> UIView {
        let postTitleView = ListsHeaderTitleView()
        postTitleView.setTitle(output?.createPostTitle ?? "")
        postTitleView.output = output as? ListsHeaderTitleViewOutput
        return postTitleView
    }
    
    @objc func loadPosts() {
        output?.requestPosts()
    }
}

private extension PostsListViewController {
    enum Sections: Int {
        case posts
        case empty
    }
    
    func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Sections, PostCellViewModel>.init(tableView: tableView, cellProvider: { [weak self] (tableView, indexPath, post) -> UITableViewCell? in
            guard let self = self else { return nil }
            guard let section = Sections(rawValue: indexPath.section) else { return nil }
            switch section {
            case .posts:
                let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.cellID, for: indexPath) as! PostCell
                guard let model = self.output?.post(at: indexPath) else { return nil }
                cell.output = self
                cell.config(model: model)
                return cell
            case .empty:
                return nil
            }
        })
    }
}

extension PostsListViewController: PostCellOutput {
    func revealCell(_ cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        output?.reveal(at: indexPath)
    }
    
    func likePost(_ cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        output?.likePost(at: indexPath)
    }
    
    func presentMenu(_ cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        output?.presentMenu(at: indexPath)
    }
    
    func openUserProfile(_ cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        output?.openUserProfile(at: indexPath)
    }
}

//MARK: UITableViewDelegate
extension PostsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Sections(rawValue: indexPath.section),
              let output = output else { fatalError() }
        switch section {
        case .posts:
            return output.rowHeight(at: indexPath)
        case .empty:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Sections(rawValue: indexPath.section),
              let output = output else { fatalError() }
        switch section {
        case .posts:
            return output.rowHeight(at: indexPath)
        case .empty:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = Sections(rawValue: section) else { fatalError() }
        switch section {
        case .posts:
            return postTitleView()
        case .empty:
            return infoView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = Sections(rawValue: section),
              let output = output else { fatalError() }
        switch section {
        case .posts:
            return output.postsTitleHeight
        case .empty:
            return output.infoTitleHeight
        }
    }
}
