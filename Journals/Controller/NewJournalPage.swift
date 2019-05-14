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

    let imgBackground: UIView = {

        let view = UIView()

        return view
    }()

    lazy var journalImageView: UIImageView = {

        let imgView = UIImageView()
        imgView.backgroundColor = .clear
        imgView.image = UIImage(named: "icon_photo")
        imgView.tintColor = .white
        imgView.contentMode = .center
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imgViewSelect))
        imgView.addGestureRecognizer(gesture)
        imgView.isUserInteractionEnabled = true
        imgView.clipsToBounds = true

        return imgView
    }()

    lazy var titleTextField: UITextField = {

        let textField = UITextField()
        textField.placeholder = "Title"
        textField.delegate = self

        return textField
    }()

    let separator: UIView = {

        let view = UIView()
        view.backgroundColor = UIColor(r: 171, g: 179, b: 176, a: 1)

        return view
    }()

    let contentTextView: UITextView = {

        let textView = UITextView()
        let textAttributes: [NSAttributedString.Key: Any] = [

            .font: UIFont.systemFont(ofSize: 18, weight: .regular),
            .foregroundColor: UIColor(r: 131, g: 156, b: 152, a: 1),
            .kern: 0.01
        ]
        textView.typingAttributes = textAttributes

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

        let textAttributes: [NSAttributedString.Key: Any] = [

            .font: UIFont.systemFont(ofSize: 20, weight: .regular),
            .foregroundColor: UIColor.white,
            .kern: 0.01

        ]

        let attributedString = NSAttributedString(string: "Save", attributes: textAttributes)
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.layer.applySketchShadow(
            color: UIColor(r: 247, g: 174, b: 163, a: 1),
            alpha: 1,
            xPosition: 0,
            yPosition: 0,
            blur: 10,
            spread: 0)

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

        view.addSubview(imgBackground)
        imgBackground.addSubview(journalImageView)
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let gradient = CAGradientLayer()
        let slate = UIColor(r: 67, g: 87, b: 97, a: 1).cgColor
        let dark = UIColor(r: 26, g: 34, b: 38, a: 1).cgColor

        gradient.frame = imgBackground.bounds
        gradient.colors = [slate, dark]

        imgBackground.layer.insertSublayer(gradient, at: 0)

    }

    @objc func saveButtonTapped() {

        let newJournal = Journal(context: context!)

        let pngData = self.journalImageView.image?.pngData()

        newJournal.image = pngData
        newJournal.title = self.titleTextField.text
        newJournal.content = self.contentTextView.text
        newJournal.date = Date()

        do {

            try context?.save()

        } catch {

            print(error)

        }

        self.dismiss(animated: true, completion: nil)

    }

    @objc func dismissButtonTapped() {

        self.dismiss(animated: true, completion: nil)

    }

    private func setLayout() {

        imgBackground.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            size: CGSize.init(width: 0, height: 375)
        )

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

extension NewJournalPage: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {

        let textAtrributes: [NSAttributedString.Key: Any] = [

            NSAttributedString.Key.foregroundColor: UIColor(r: 67, g: 87, b: 97, a: 1),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .regular),
            NSAttributedString.Key.kern: 0.01

        ]

        textField.typingAttributes = textAtrributes

    }
}
