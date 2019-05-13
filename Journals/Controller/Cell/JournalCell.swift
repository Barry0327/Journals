//
//  JournalCell.swift
//  Journals
//
//  Created by Chen Yi-Wei on 2019/5/13.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit

class JournalCell: UITableViewCell {

    var journal: Journal? {

        didSet {

            let image = UIImage(data: (journal?.image)!)

            journalImageView.image = image!
            titleLabel.text = journal?.title

        }
    }

    private let journalImageView: UIImageView = {

        let imgView = UIImageView()
        imgView.layer.cornerRadius = 8
        imgView.backgroundColor = .red
        imgView.clipsToBounds = true

        return imgView
    }()

    private let titleLabel: UILabel = {

        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(r: 67, g: 87, b: 97, a: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        return label
    }()

    private let separator: UIView = {

        let view = UIView()
        view.backgroundColor = UIColor(r: 171, g: 179, b: 176, a: 1)

        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(journalImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(separator)

        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayout() {

        journalImageView.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 10, left: 20, bottom: 60, right: 20)
        )

        titleLabel.anchor(
            top: journalImageView.bottomAnchor,
            leading: contentView.leadingAnchor,
            bottom: nil,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 16, left: 30, bottom: 0, right: 30),
            size: .init(width: 0, height: 16)
        )

        separator.anchor(
            top: titleLabel.bottomAnchor,
            leading: contentView.leadingAnchor,
            bottom: nil,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 19.8, left: 30, bottom: 0, right: 30),
            size: .init(width: 0, height: 0.5)
        )
    }
}
