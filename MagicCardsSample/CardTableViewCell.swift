//
//  CardTableViewCell.swift
//  MagicCardsSample
//
//  Created by Sultan on 11.09.2023.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    static let cellId = "cardCell"

    var cardModel: Card? {
        didSet {
            nameLabel.text = cardModel?.name
            typeLabel.text = cardModel?.type

            DispatchQueue.global(qos: .userInteractive).async {
                guard let imagePath = self.cardModel?.imageUrl,
                      let imageURL = URL(string: imagePath),
                      let imageData = try? Data(contentsOf: imageURL)
                else {
                    DispatchQueue.main.async {
                        self.iconImageView.image = UIImage(systemName: "sailboat.circle")
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.iconImageView.image = UIImage(data: imageData)
                }
            }
        }
    }

    // MARK: - UI

    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()

    lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        nameLabel.text = nil
        typeLabel.text = nil
    }

    // MARK: - Setup Views

    private func setupViews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(typeLabel)
    }

    // MARK: - Setup Constraints

    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.size.equalTo(100)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalTo(iconImageView.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-10)
        }
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.leading.equalTo(iconImageView.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
}
