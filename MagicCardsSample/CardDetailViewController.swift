//
//  CardDetailViewController.swift
//  MagicCardsSample
//
//  Created by Sultan on 14.09.2023.
//

import UIKit
import SnapKit

class CardDetailViewController: UIViewController {

    var cardModel: Card? {
        didSet {
            nameLabel.text = "Name: \(cardModel?.name ?? "")"
            typeLabel.text = "Type: \(cardModel?.type ?? "")"
            textLabel.text = cardModel?.text

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
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()

    lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()

    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    // MARK: - Setup Views

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(iconImageView)
        view.addSubview(nameLabel)
        view.addSubview(typeLabel)
        view.addSubview(textLabel)
    }

    // MARK: - Setup Constraints

    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(300)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }

}
