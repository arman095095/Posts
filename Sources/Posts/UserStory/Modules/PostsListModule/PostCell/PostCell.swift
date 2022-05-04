//
//  File.swift
//  
//
//  Created by Арман Чархчян on 03.05.2022.
//

import Foundation
import UIKit
import SDWebImage
import DesignSystem

protocol PostCellOutput: AnyObject {
    func revealCell(_ cell: UITableViewCell)
    func likePost(_ cell: UITableViewCell)
    func presentMenu(_ cell: UITableViewCell)
    func openUserProfile(_ cell: UITableViewCell)
}

final class PostCell: UITableViewCell {
    
    static let cellID = Constants.cellID
    weak var output: PostCellOutput?
    private var model: PostCellViewModelProtocol?
    
    //Первый слой
    private let cardView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    //TopViews
    private let topView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let personImage: UIImageView = {
        var view = UIImageView()
        view.layer.cornerRadius = PostCellConstants.userImageHeight/2
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let nameLabel: UILabel = {
        var view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15)
        view.textColor = .link
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let dateLabel: UILabel = {
        var view = UILabel()
        view.textColor = UIColor.postGrey()
        view.font = UIFont.systemFont(ofSize: 13)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let ownerButton: SmallButton = {
        let button = SmallButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGray2
        return button
    }()
    private var bottonViewTopConstraint: NSLayoutConstraint!
    
    //dynamic Views withoutConstraints
    private let postsImageView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    private let postTextView: UITextView = {
        var view = UITextView()
        view.font = PostCellConstants.postsTextFont
        view.isScrollEnabled = false
        view.isEditable = false
        view.isSelectable = true
        let padding = view.textContainer.lineFragmentPadding
        view.textContainerInset = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        view.dataDetectorTypes = UIDataDetectorTypes.all
        return view
    }()
    private let fullTextButton : UIButton = {
        var view = UIButton(type: UIButton.ButtonType.system)
        view.titleLabel?.font = PostCellConstants.buttonFont
        view.setTitle(PostCellConstants.buttonTitle, for: .normal)
        return view
    }()
    private lazy var onlineImageView: UIImageView = {
        var view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = UIColor.onlineColor()
        view.layer.cornerRadius = 7.5
        view.layer.borderWidth = 3
        view.layer.borderColor = cardView.backgroundColor?.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    private let bottonView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let likesView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let likeButton: UIButton = {
        var view = UIButton(type: .system)
        view.tintColor = UIColor.postGrey()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let likesCountLabel: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor.postGrey()
        view.lineBreakMode = .byWordWrapping
        view.font = UIFont.systemFont(ofSize: 13,weight: .medium)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        setupActions()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.personImage.image = nil
        self.onlineImageView.isHidden = true
        self.postsImageView.image = nil
        self.likeButton.tintColor = UIColor.postGrey()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(model: PostCellViewModelProtocol) {
        self.model = model
        personImage.sd_setImage(with: model.ownerImageUrl)
        nameLabel.text = model.userName
        onlineImageView.isHidden = !model.onlineIconShow
        dateLabel.text = model.date
        postTextView.text = model.textContent
        postsImageView.sd_setImage(with: model.urlImage)
        postTextView.frame = model.textContentFrame
        postsImageView.frame = model.postImageFrame
        fullTextButton.frame = model.buttonFrame
        likesCountLabel.text = model.likesCount
        likeButton.tintColor = model.likedByMe ? .systemRed : UIColor.postGrey()
        bottonViewTopConstraint.constant = model.contentInset
        ownerButton.isHidden = !model.menuButtonShow
        layoutIfNeeded()
    }
    
    @objc private func showFullTapped() {
        output?.revealCell(self)
    }
    
    @objc private func likeTapped() {
        guard let model = model else { return }
        likeButton.tintColor = model.likedByMe ? UIColor.postGrey() : .systemRed
        likesCountLabel.text = model.likesCountAfterLike
        output?.likePost(self)
    }
    
    @objc private func menuButtonTapped() {
        output?.presentMenu(self)
    }
    
    @objc private func profileTapped() {
        output?.openUserProfile(self)
    }
}

//MARK: Setup UI
private extension PostCell {
    
    func setupViews() {
        onlineImageView.image = UIImage(named: Constants.onlineImageName)
        ownerButton.setImage(UIImage(named: Constants.ownerButtonImageName), for: .normal)
        let config = UIImage.SymbolConfiguration(weight: UIImage.SymbolWeight.medium)
        likeButton.setImage(UIImage(systemName: Constants.likeButtonSystemImageName, withConfiguration: config), for: .normal)
        backgroundColor = .clear
        cardView.layer.cornerRadius = 8
        cardView.clipsToBounds = true
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 2.5, height: 4)
        layer.shadowColor = UIColor.black.cgColor
    }
    
    func setupActions() {
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        fullTextButton.addTarget(self, action: #selector(showFullTapped), for: .touchUpInside)
        ownerButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        personImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileTapped)))
        topView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileTapped)))
    }
    
    func setupConstraints() {
        setupConstraintsForCard()
        setupConstraintsForTopView()
        setupConstraintsForIconImage()
        setupConstraintsForOwnerButton()
        setupConstraintsForNameLabel()
        setupConstraintsForDateLabel()
        setupConstraintsForOnlineImageView()
        setupConstraintsForBottonView()
        setupConstraintsForLikesView()
        setupConstraintsForLikes()
    }
    
    func setupConstraintsForCard() {
        self.contentView.addSubview(cardView)
        cardView.addSubview(postsImageView)
        cardView.addSubview(postTextView)
        cardView.addSubview(fullTextButton)
        cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: PostCellConstants.cardViewSideInset).isActive = true
        cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -PostCellConstants.cardViewSideInset).isActive = true
        cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -PostCellConstants.cardViewBottonInset).isActive = true
        cardView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    //Constreints topView
    func setupConstraintsForTopView() {
        cardView.addSubview(topView)
        topView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: PostCellConstants.heightTopView).isActive = true
        topView.topAnchor.constraint(equalTo: cardView.topAnchor).isActive = true
    }
    
    func setupConstraintsForIconImage() {
        topView.addSubview(personImage)
        personImage.heightAnchor.constraint(equalToConstant: PostCellConstants.userImageHeight).isActive = true
        personImage.widthAnchor.constraint(equalToConstant: PostCellConstants.userImageHeight).isActive = true
        personImage.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: PostCellConstants.contentInset).isActive = true
        personImage.topAnchor.constraint(equalTo: topView.topAnchor, constant: 8).isActive = true
    }
    
    func setupConstraintsForNameLabel() {
        topView.addSubview(nameLabel)
        nameLabel.trailingAnchor.constraint(equalTo: ownerButton.leadingAnchor, constant: -PostCellConstants.contentInset).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: personImage.trailingAnchor, constant: 8).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 14).isActive = true
    }
    
    func setupConstraintsForDateLabel() {
        topView.addSubview(dateLabel)
        dateLabel.trailingAnchor.constraint(equalTo: ownerButton.leadingAnchor, constant: -8).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: personImage.trailingAnchor, constant: 8).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -14).isActive = true
    }
    
    func setupConstraintsForOnlineImageView() {
        topView.addSubview(onlineImageView)
        onlineImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        onlineImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        onlineImageView.bottomAnchor.constraint(equalTo: personImage.bottomAnchor, constant: 0).isActive = true
        onlineImageView.trailingAnchor.constraint(equalTo: personImage.trailingAnchor, constant: 0).isActive = true
    }
    
    func setupConstraintsForOwnerButton() {
        topView.addSubview(ownerButton)
        ownerButton.heightAnchor.constraint(equalToConstant: PostCellConstants.menuButtonHeight).isActive = true
        ownerButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        ownerButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        ownerButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -PostCellConstants.contentInset).isActive = true
    }
    
    func setupConstraintsForBottonView() {
        cardView.addSubview(bottonView)
        
        bottonViewTopConstraint = bottonView.topAnchor.constraint(equalTo: postsImageView.bottomAnchor)
        bottonViewTopConstraint.isActive = true
        bottonView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor).isActive = true
        bottonView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor).isActive = true
        bottonView.heightAnchor.constraint(equalToConstant: PostCellConstants.heightButtonView).isActive = true
        bottonView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor).isActive = true
    }
    
    func setupConstraintsForLikesView() {
        bottonView.addSubview(likesView)
        likesView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        likesView.leadingAnchor.constraint(equalTo: bottonView.leadingAnchor, constant: PostCellConstants.contentInset - 2).isActive = true
        likesView.topAnchor.constraint(equalTo: bottonView.topAnchor).isActive = true
        likesView.bottomAnchor.constraint(equalTo: bottonView.bottomAnchor).isActive = true
    }
    
    func setupConstraintsForLikes() {
        likesView.addSubview(likeButton)
        likesView.addSubview(likesCountLabel)
        likeButton.widthAnchor.constraint(equalToConstant: 26).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        likeButton.centerYAnchor.constraint(equalTo: likesView.centerYAnchor).isActive = true
        likeButton.leadingAnchor.constraint(equalTo: likesView.leadingAnchor).isActive = true
        likesCountLabel.centerYAnchor.constraint(equalTo: likesView.centerYAnchor).isActive = true
        likesCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor,constant: 3).isActive = true
        likesCountLabel.trailingAnchor.constraint(equalTo: likesView.trailingAnchor).isActive = true
    }
}

private extension PostCell {
    struct Constants {
        static let cellID = "PostCell"
        static let onlineImageName = "online"
        static let ownerButtonImageName = "menu"
        static let likeButtonSystemImageName = "heart"
    }
}
