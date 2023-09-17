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

    private var cards: [Card]?
    private var searchResults: [Card]?

    // MARK: - UI

    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.textColor = .black
        textField.setLeftPadding(10.0)
        textField.setRightPadding(10.0)
        textField.layer.cornerRadius = 15
        textField.backgroundColor = UIColor(red: 0.75, green: 0.83, blue: 0.95, alpha: 1.00)
        return textField
    }()

    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(searchCards), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 0.75, green: 0.83, blue: 0.95, alpha: 1.00)
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
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: CardTableViewCell.cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        fetchCards()
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
            make.top.equalToSuperview().offset(80)
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
        searchButton.snp.makeConstraints { make in
            make.leading.equalTo(searchTextField.snp.trailing).offset(10)
            make.top.equalToSuperview().offset(80)
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
        cardsTableView.snp.makeConstraints { make in
            make.top.equalTo(searchButton.snp.bottom).offset(10)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }

    // MARK: - Fetch data

    func fetchCards() {
        let request = AF.request("https://api.magicthegathering.io/v1/cards?pageSize=30")
        request.responseDecodable(of: Cards.self) { (data) in
            guard let response = data.value else {
                self.showUIAlert(message: "Something went wrong!")
                return
            }
            let cards = response.cards.filter { $0.imageUrl != nil }
            self.cards = cards
            self.cardsTableView.reloadData()
        }
    }

    @objc func searchCards() {
        guard let param = searchTextField.text,
        param.count > 0 else {
            self.showUIAlert(message: "Enter search parameters!")
            return
        }
        let url = "https://api.magicthegathering.io/v1/cards?pageSize=30&name=\(param)"
        let request = AF.request(url)
        request.responseDecodable(of: Cards.self) { data in
            guard let response = data.value else { return }
            let cards = response.cards.filter { $0.imageUrl != nil }
            guard cards.count > 0 else {
                self.showUIAlert(message: "No results!")
                return
            }
            self.cards = cards
            self.cardsTableView.reloadData()
        }
    }

    func showUIAlert(message: String) {
        let action = UIAlertAction(title: "OK", style: .destructive)
        let alertController
            = UIAlertController(title: "Error!",
                                message: message,
                                preferredStyle: .alert)
        alertController.addAction(action)
        self.present(alertController, animated: true)
    }

}

    // MARK: - Table View

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = cards?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.cellId, for: indexPath) as? CardTableViewCell
        cell?.cardModel = cellModel
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellModel = cards?[indexPath.row]
        let viewController = CardDetailViewController()
        viewController.cardModel = cellModel
        present(viewController, animated: true)
    }

}
