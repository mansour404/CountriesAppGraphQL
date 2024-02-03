//
//  NetworkService.swift
//  CountriesApp
//
//  Created by Mohamed Adel on 03/02/2024.
//

import Foundation
import Apollo

class NetworkService {
    static let shared = NetworkService()
    private init() { }
    private let url = URL(string: "https://countries.trevorblades.com/")!
    lazy private (set) var apollo = ApolloClient(url: url)
}
