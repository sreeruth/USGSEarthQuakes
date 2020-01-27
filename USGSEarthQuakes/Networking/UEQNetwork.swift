//
//  UEQNetwork.swift
//  USGSEarthQuakes
//
//  Created by Sreekanth Ruthala on 1/26/20.
//  Copyright © 2020 Sreekanth Ruthala. All rights reserved.
//

import Foundation

typealias UEQNetworkCallback = (Result<Data, DataResponseError>) -> ()
class UEQNetwork {
    fileprivate let session: URLSession!
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    func fetchData(with requestURL: URL, completionHandler: @escaping UEQNetworkCallback) {
        self.session.dataTask(with: requestURL) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.hasSuccessStatusCode,
              let data = data else {
                completionHandler(Result.failure(DataResponseError.network))
                return
            }
            completionHandler(Result.success(data))
        }.resume()
    }
}

enum DataResponseError: Error {
  case network
  case decoding
  
  var reason: String {
    switch self {
    case .network:
      return "An error occurred while fetching data ".localizedString
    case .decoding:
      return "An error occurred while decoding data".localizedString
    }
  }
}

extension HTTPURLResponse {
  var hasSuccessStatusCode: Bool {
    return 200...299 ~= statusCode
  }
}

enum Result<T, U: Error> {
  case success(T)
  case failure(U)
}

extension String {
  var localizedString: String {
    return NSLocalizedString(self, comment: "")
  }
  
  var html2String: String {
    guard let data = data(using: .utf8), let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) else {
      return self
    }
    return attributedString.string
  }
}
