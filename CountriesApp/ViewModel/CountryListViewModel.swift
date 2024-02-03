//
//  CountryListViewModel.swift
//  CountriesApp
//
//  Created by Mohamed Adel on 03/02/2024.
//

import Foundation
import CountriesGraphQLAPI
import Apollo

// MARK: - Protocols
protocol ViewModelProtocol {
    var getItemsCount: Int { get }
    func configuarCell(_ cell: CountryCellProtocol, at index: Int)
}

protocol ViewModelNavigationProtocol {
    func getselectedItem(at index: Int) -> CountryViewModel
}


// MARK: - ViewModel
class CountryListViewModel {
    private let network: NetworkService = NetworkService.shared
    var countries: [CountryViewModel] = [] {
        didSet {
            reloadTableViewClosure?()
        }
    }
//    var countries: [GetAllCountriesQuery.Data.Country] = [] {
//        didSet {
//        }
//    }
    var alertMessage: String? {
        didSet {
            alertClosure?()
        }
    }
    
    var alertClosure: (() -> ())?
    var reloadTableViewClosure: (() -> ())?
    var loadingIndicatorClosure: ((Bool) -> ())?

    func viewDidLoad() {
        loadingIndicatorClosure?(true)
        network.apollo.fetch(query: GetAllCountriesQuery()) {[weak self] result in
            guard let self else { return }
            switch result {
            case .success(let graphQLResult):
                loadingIndicatorClosure?(false)
                guard let countries = graphQLResult.data?.countries else { return }
                self.countries = countries.map { CountryViewModel.init(country: $0)}
                //self.countries = countries.map(CountryViewModel.init)
            case .failure(let error):
                loadingIndicatorClosure?(false)
                print(error.localizedDescription)
                self.alertMessage = error.localizedDescription
            }
        }
    }
}

// MARK: - Conform Protocol
extension CountryListViewModel: ViewModelProtocol, ViewModelNavigationProtocol {
    var getItemsCount: Int {
        return countries.count
    }
    
    func configuarCell(_ cell: CountryCellProtocol, at index: Int){
        let country = countries[index]
        cell.displayEmoji(country.emoji)
        cell.displayName(country.name)
    }
    
    func getselectedItem(at index: Int) -> CountryViewModel {
        countries[index]
    }
}


// MARK: - CountryViewModel
struct CountryViewModel {
    fileprivate var country: GetAllCountriesQuery.Data.Country
    
    var code: ID {
        country.code
    }
    
    var name: String {
        country.name
    }
    
    var emoji: String {
        country.emoji
    }
}



