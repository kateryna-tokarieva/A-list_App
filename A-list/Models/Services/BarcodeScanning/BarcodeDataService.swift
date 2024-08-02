//
//  BarcodeDataService.swift
//  A-list
//
//  Created by Екатерина Токарева on 06.07.2024.
//

import Foundation
import Combine

struct BarcodeDataService {
    static let shared = BarcodeDataService()
    
    private init() {}
    
    func fetchProduct(by barcode: String) -> AnyPublisher<BarcodeData, Error> {
        guard let url = URL(string: "https://world.openfoodfacts.org/api/v0/product/\(barcode).json") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: BarcodeData.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
