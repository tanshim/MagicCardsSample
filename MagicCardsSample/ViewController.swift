//
//  ViewController.swift
//  MagicCardsSample
//
//  Created by Sultan on 06.09.2023.
//

import UIKit
import Alamofire
import SnapKit

class ViewController: UIViewController {

    private var cards: [Card] = []

    // MARK: - UI

    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.textColor = .black
        textField.setLeftPadding(10.0)
        textField.setRightPadding(10.0)
        textField.layer.cornerRadius = 15
        textField.backgroundColor = .clear
        return textField
    }()

    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.42, green: 0.45, blue: 0.81, alpha: 1.00)
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10
        button.layer.shouldRasterize = true
        button.layer.rasterizationScale = UIScreen.main.scale
        return button
    }()

    private lazy var cardsTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: "cardCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        return tableView
    }()


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCards()
        setupViews()
        setupConstraints()
    }

    // MARK: - Setup

    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        view.addSubview(cardsTableView)
    }

    func setupConstraints() {
        searchTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
        searchButton.snp.makeConstraints { make in
            make.leading.equalTo(searchTextField.snp.trailing).offset(10)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
        cardsTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(searchTextField.snp.bottom).offset(10)
        }
    }

    // MARK: - Fetch data

    func fetchCards() {
        let request = AF.request("https://api.magicthegathering.io/v1/cards")
        request.responseDecodable(of: Cards.self) { (data) in
            print(data.response?.statusCode)
            guard let response = data.value else { return }
            //print(data.value)
            let cards = response.cards
            print(cards.first ?? "Empty")
            self.cards = cards
            self.cardsTableView.reloadData()
        }
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = cards[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as? CardTableViewCell
//        cell?.cardModel = cellModel
//        print(cell ?? "empty1")
        cell?.nameLabel.text = cellModel.name
        cell?.typeLabel.text = cellModel.type
        guard let imagePath = cellModel.imageUrl,
              let imageURL = URL(string: imagePath),
              let imageData = try? Data(contentsOf: imageURL)
        else {
            cell?.iconImageView.image = UIImage(systemName: "sailboat.circle")
            return cell ?? UITableViewCell()
        }
        cell?.iconImageView.image = UIImage(data: imageData)
        return cell ?? UITableViewCell()
    }

}

extension UITextField {
    func setLeftIcon(_ image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 25, y: 2.5, width: 25, height: 25))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame: CGRect(x: 30, y: 0, width: 55, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }

    func setLeftPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame:
                                    CGRect(x: 0, y: 0, width: padding,
                                           height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    func setRightPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame:
                                    CGRect(x: 0, y: 0, width: padding,
                                           height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
