//
//  ViewController.swift
//  Journals
//
//  Created by Chen Yi-Wei on 2019/5/13.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit

class NewJournalPage: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    lazy var journalImageView: UIImageView = {

        let imgView = UIImageView()
        imgView.backgroundColor = UIColor(r: 26, g: 34, b: 38, a: 1)
        imgView.image = UIImage(named: "icon_photo")
        imgView.tintColor = .white
        imgView.contentMode = .center
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imgViewSelect))
        imgView.addGestureRecognizer(gesture)
        imgView.isUserInteractionEnabled = true
        imgView.clipsToBounds = true

        return imgView
    }()

    let titleTextField: UITextField = {

        let textField = UITextField()
        textField.placeholder = "Title"

        return textField
    }()

    let separator: UIView = {

        let view = UIView()
        view.backgroundColor = UIColor(r: 171, g: 179, b: 176, a: 1)

        return view
    }()

    let contentTextView: UITextView = {

        let textView = UITextView()

        return textView
    }()

    let bottomContainer: UIView = {

        let view = UIView()

        return view
    }()

    lazy var saveButton: UIButton = {

        let button = UIButton()
        button.layer.cornerRadius = 22
        button.backgroundColor = UIColor(r: 237, g: 96, b: 81, a: 1)
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        return button
    }()

    lazy var dismissButton: UIButton = {

        let button = UIButton()
        button.setImage(UIImage(named: "button_close"), for: .normal)
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()

        view.addSubview(journalImageView)
        view.addSubview(titleTextField)
        view.addSubview(separator)
        view.addSubview(contentTextView)

        view.addSubview(bottomContainer)
        bottomContainer.addSubview(saveButton)
        journalImageView.addSubview(dismissButton)

        setLayout()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(notifiction:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(notificiton:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

    }

    @objc func saveButtonTapped() {

        let newJournal = Journal(context: context!)

        let pngData = self.journalImageView.image?.pngData()

        newJournal.image = pngData
        newJournal.title = self.titleTextField.text
        newJournal.content = self.contentTextView.text

        do {
            try context?.save()
        } catch {
            print(error)
        }

    }

    @objc func dismissButtonTapped() {

        self.dismiss(animated: true, completion: nil)

    }

    private func setLayout() {

        journalImageView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            size: CGSize.init(width: 0, height: 375)
        )

        titleTextField.anchor(
            top: journalImageView.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 10, left: 22, bottom: 0, right: 22),
            size: .init(width: 0, height: 36)
        )

        separator.anchor(
            top: titleTextField.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 10, left: 22, bottom: 0, right: 22),
            size: .init(width: 0, height: 0.5)
        )

        bottomContainer.anchor(
            top: nil,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor,
            size: .init(width: 0, height: 64)
        )

        saveButton.anchor(
            top: bottomContainer.topAnchor,
            leading: bottomContainer.leadingAnchor,
            bottom: bottomContainer.bottomAnchor,
            trailing: bottomContainer.trailingAnchor,
            padding: .init(top: 12, left: 108, bottom: 8, right: 107)
        )

        contentTextView.anchor(
            top: separator.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: bottomContainer.topAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 9.5, left: 22, bottom: 0, right: 22)
        )

        dismissButton.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 29, left: 20, bottom: 0, right: 0),
            size: .init(width: 36, height: 36)
        )
    }

}

extension NewJournalPage: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @objc func imgViewSelect() {

        let picker = UIImagePickerController()

        picker.delegate = self

        self.present(picker, animated: true, completion: nil)

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        var selectImage: UIImage?

        if let originalImage = info[.originalImage] as? UIImage {
            selectImage = originalImage
        }

        self.journalImageView.contentMode = .scaleAspectFill
        self.journalImageView.image = selectImage

        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        self.dismiss(animated: true, completion: nil)

    }
}
