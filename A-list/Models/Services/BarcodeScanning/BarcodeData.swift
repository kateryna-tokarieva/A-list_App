//
//  BarcodeData.swift
//  A-list
//
//  Created by Екатерина Токарева on 06.07.2024.
//

import Foundation

struct BarcodeData: Codable {
    let product: ProductItem
    
    func asShoppingItem() -> ShoppingItem {
        ShoppingItem(title: "\(product.productName) (\(product.brands))", quantity: "1", unit: .pc)
    }
}

struct ProductItem: Codable {
    let productName: String
    let brands: String
    
    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case brands = "brands"
    }
}
