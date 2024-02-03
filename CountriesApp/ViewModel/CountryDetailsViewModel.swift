//
//  CountryDetailsViewModel.swift
//  CountriesApp
//
//  Created by Mohamed Adel on 03/02/2024.
//

import Foundation
import CountriesGraphQLAPI
import Apollo

// MARK: - ViewModel
class CountryDetailsViewModel {
    private var country: GetCountryInfoQuery.Data.Country? {
        didSet {
            updateLabelsClosure?(name, capital)
            reloadViewClosure?()
        }
    }
    
    var requestState: RequestState = .empty {
        didSet {
            updateLoadingStatus?()
        }
    }
    
    var reloadViewClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var updateLabelsClosure: ((String, String) -> ())?
    
    private var name: String {
        country?.name ?? ""
    }
    
    private var capital: String {
        country?.capital ?? ""
    }
    
    var state: [StateViewModel] {
//        country?.states.map(StateViewModel.init)
        return country?.states.map(StateViewModel.init) ?? []
    }
    
    func getCountryInfoByCode(code: ID!) {
        requestState = .loading
        NetworkService.shared.apollo.fetch(query: GetCountryInfoQuery(code: code)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let graphQLResult):
                self.country = graphQLResult.data?.country
                if graphQLResult.data?.country?.states.isEmpty ?? false {
                    requestState = .empty
                } else {
                    requestState = .populated
                }
            case .failure(let error):
                requestState = .error
                print(error.localizedDescription)
            }
        }
    }
    
}

// MARK: - Conform Protocol
extension CountryDetailsViewModel: ViewModelProtocol {
    var getItemsCount: Int {
        return country?.states.count ?? 0
    }
    
    func configuarCell(_ cell: CountryCellProtocol, at index: Int){
        guard let state = country?.states[index] else { return }
        cell.displayEmoji(state.code ?? "")
        cell.displayName(state.name)
    }
}

// MARK: - StateViewModel
struct StateViewModel: Identifiable {
    fileprivate let state: GetCountryInfoQuery.Data.Country.State
    let id = UUID()
    
    var name: String {
        state.name
    }
}

// MARK: - State
enum RequestState {
    case loading
    case error
    case empty
    case populated
}
