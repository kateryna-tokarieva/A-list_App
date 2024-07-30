//
//  BarcodeDataService.swift
//  A-list
//
//  Created by Екатерина Токарева on 06.07.2024.
//

import Foundation

struct BarcodeDataService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchData(search: String, completionHandler: @escaping (BarcodeData) -> Void) {
        let url = self.searchURL(for: search)
        performRequest(withURL: url, completionHandler: completionHandler)
    }
    
    private func performRequest(withURL url: URL?, completionHandler: @escaping (BarcodeData) -> Void) {
        guard let url = url else {
            // Handle the case where the URL is nil
            return
        }
        session.dataTask(with: url) { data, response, error in
            if let data = data,
               let textBookSearchData = self.parseJSON(withData: data) {
                completionHandler(textBookSearchData)
            }
        }.resume()
    }
    
    private func parseJSON(withData data: Data) -> BarcodeData? {
        let decoder = JSONDecoder()
        var barcodeData: BarcodeData?
        do {
            barcodeData = try decoder.decode(BarcodeData.self, from: data)
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        return barcodeData
    }
    
    private func searchURL(for search: String) -> URL? {
        let urlString = "\(API.base)\(search).json"
        guard let url = URL(string: urlString) else { return nil }
        return url
    }
}
