//
//  PostCreateViewController.swift
//  
//
//  Created by Арман Чархчян on 02.05.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import DesignSystem
import AlertManager
import InputBarAccessoryView

protocol PostCreateViewInput: AnyObject {
    func setupInitialState(stringFactory: PostCreateStringFactoryProtocol)
    func successSelectedPhoto(photo: UIImage, photo size: CGSize)
    func setupInitialLayout()
    func sendButtonEnabled(on: Bool)
    func blockUI()
    func unlockUI()
}

final class PostCreateViewController: UIViewController {

    var output: PostCreateViewOutput?

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleToFill
        return view
    }()

    private let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor.mainApp()
        return button
    }()

    private let textView: InputTextView = {
        let inputTextView = InputTextView()
        inputTextView.backgroundColor = .systemBackground
        inputTextView.isScrollEnabled = true
        inputTextView.placeholderTextColor = .gray
        inputTextView.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 21, right: 36)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 14, left: 15, bottom: 14, right: 36)
        inputTextView.layer.borderColor = UIColor.gray.cgColor
        inputTextView.layer.borderWidth = 0.2
        inputTextView.layer.cornerRadius = 18.0
        inputTextView.layer.masksToBounds = true
        inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
        return inputTextView
    }()

    private let scrollView = UIScrollView()
    
    private let activity: CustomActivityIndicator = {
        let view = CustomActivityIndicator()
        view.strokeColor = UIColor.mainApp()
        view.lineWidth = 3.5
        view.bounds.size = CGSize(width: 43, height: 43)
        return view
    }()

    private var keyboardHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
}

extension PostCreateViewController: PostCreateViewInput {
    
    func setupInitialState(stringFactory: PostCreateStringFactoryProtocol) {
        setupNavigationBar(stringFactory: stringFactory)
        setupKeyboardObservers()
        setupViews(stringFactory: stringFactory)
        setupActions()
        setupInputViewForTextView()
    }
    
    func setupInitialLayout() {
        imageView.image = nil
        scrollView.frame = view.bounds
        imageView.frame = .zero
        textView.frame = view.bounds
        textView.frame.size.height = keyboardHeight == nil ? view.bounds.height : view.bounds.height - keyboardHeight! - topBarHeight
        removeButton.frame = .zero
        scrollView.contentSize = .zero
        activity.frame.origin.y = view.frame.maxY - activity.bounds.height - topBarHeight - (keyboardHeight ?? 0)
        activity.frame.origin.x = view.center.x - activity.bounds.width/2
    }
    
    func successSelectedPhoto(photo: UIImage, photo size: CGSize) {
        layout(with: size)
        imageView.image = photo
        reloadViews()
    }
    
    func blockUI() {
        activity.startLoading()
        activity.isHidden = false
        textView.isEditable = false
        navigationItem.rightBarButtonItem?.isEnabled = false
        removeButton.isEnabled = false
        scrollView.scrollToBottom(animated: true)
    }
    
    func unlockUI() {
        activity.completeLoading(success: true)
        activity.isHidden = true
        textView.isEditable = true
        navigationItem.rightBarButtonItem?.isEnabled = true
        removeButton.isEnabled = true
        textView.becomeFirstResponder()
    }
    
    func sendButtonEnabled(on: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = on
    }
}

extension PostCreateViewController: UIPickerViewDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let photo = info[.originalImage] as? UIImage else { return }
        output?.select(image: photo, with: photo.size)
        picker.dismiss(animated: true)
    }
}

extension PostCreateViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        output?.entered(text: textView.text)
    }
}

private extension PostCreateViewController {
    
    func reloadViews() {
        scrollView.contentSize.height = imageView.frame.height + 5 + textView.frame.height + (keyboardHeight ?? 0)
        self.scrollView.scrollToBottom(animated: true)
    }
    
    func layout(with photo: CGSize) {
        scrollView.contentOffset.y = 0
        if photo.height > photo.width && photo.height > view.bounds.height - (keyboardHeight ?? 0) - topBarHeight {
            let height = view.bounds.height - (keyboardHeight ?? 0) - topBarHeight
            let ratio = photo.height/height
            let width = photo.width/ratio
            self.imageView.frame = CGRect(x: view.frame.midX - width/2, y: 0, width: width, height: height)
        } else {
            let ratio = photo.width/view.bounds.width
            let height = photo.height/ratio
            self.imageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: height)
        }
        textView.frame = CGRect(x: 0, y: imageView.frame.maxY + 5, width: view.bounds.width, height: 130)
        removeButton.frame = CGRect(x: imageView.frame.width - 46, y: 10, width: 36, height: 36)
        activity.frame.origin.y = imageView.frame.maxY
        activity.frame.origin.x = view.center.x - activity.bounds.width/2
    }
    
    @objc private func chooseImageTapped() {
        self.presentImagePicker()
    }
    
    @objc func removeImageTapped() {
        output?.removeSelectedImage()
    }
    
    @objc func createPostTapped() {
        output?.createPost(text: textView.text)
    }
}

private extension PostCreateViewController {
    func setupNavigationBar(stringFactory: PostCreateStringFactoryProtocol) {
        navigationItem.largeTitleDisplayMode = .never
        let sendButton = UIBarButtonItem(image: UIImage(named: stringFactory.sendButtonImageName, in: Bundle.module, compatibleWith: nil), style: .done, target: self, action: #selector(createPostTapped))
        let template = sendButton.image?.withRenderingMode(.alwaysTemplate)
        sendButton.image = template
        sendButton.tintColor = UIColor.mainApp()
        navigationItem.setRightBarButton(sendButton, animated: true)
    }
    
    func setupInputViewForTextView() {
        let button = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(chooseImageTapped))
        button.tintColor = UIColor.mainApp()
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.setItems([button], animated: false)
        textView.inputAccessoryView = toolBar
        textView.delegate = self
    }
    
    func setupViews(stringFactory: PostCreateStringFactoryProtocol) {
        textView.placeholder = stringFactory.textViewPlaceholderText
        removeButton.setImage(UIImage(named: stringFactory.removeButtonImageName, in: Bundle.module, compatibleWith: nil), for: .normal)
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(textView)
        imageView.addSubview(removeButton)
        scrollView.addSubview(activity)
    }
    
    func setupActions() {
        removeButton.addTarget(self, action: #selector(removeImageTapped), for: .touchUpInside)
    }
}

private extension PostCreateViewController {
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboard),name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @objc func keyboard(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
        if notification.name == UIResponder.keyboardDidShowNotification {
            if self.keyboardHeight == nil {
                self.keyboardHeight = keyboardHeight
                output?.keyboardDidShow()
            }
        }
    }
}
