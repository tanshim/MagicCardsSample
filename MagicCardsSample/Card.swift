//
//  Card.swift
//  MagicCardsSample
//
//  Created by Sultan on 10.09.2023.
//

import Foundation

struct Cards: Decodable {
    let cards: [Card]
}

struct Card: Decodable {
    let name: String
    let type: String
    let imageUrl: String?
    let text: String
}
