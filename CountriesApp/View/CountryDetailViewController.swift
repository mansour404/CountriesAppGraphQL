//
//  CountryDetailViewController.swift
//  CountriesApp
//
//  Created by Mohamed Adel on 03/02/2024.
//

import UIKit

class CountryDetailViewController: UIViewController {
    // MARK: - Vars
    var country: CountryViewModel?
    var viewModel: CountryDetailsViewModel = CountryDetailsViewModel()
    
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryCapitalLabel: UILabel!
    @IBOutlet weak var errorView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }

    private func initView() {
        navigationItem.title = "Country info."
        navigationController?.navigationBar.prefersLargeTitles = false
        errorView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "CountryCell")
    }

    private func initViewModel() {
        viewModel.reloadViewClosure = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.countryNameLabel.reloadInputViews()
                self.countryCapitalLabel.reloadInputViews()
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self else { return }
            DispatchQueue.main.async {
                switch self.viewModel.requestState {
                case .empty, .error:
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.tableView.alpha = 0.0 // hide collection view
                    })
                    self.errorView.isHidden = false
                case .loading:
                    self.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.tableView.alpha = 0.0 // hide collection view
                    })
                    self.errorView.isHidden = true
                case .populated:
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.tableView.alpha = 1.0 // show collection view
                    })
                    self.errorView.isHidden = true
                }
            }
        }
        
        viewModel.updateLabelsClosure = { [weak self] name, capital in
            guard let self else { return }
            DispatchQueue.main.async {
                self.countryNameLabel.text = name
                self.countryCapitalLabel.text = capital
            }
        }
        
        viewModel.getCountryInfoByCode(code: country?.code)
    }
}

// MARK: - DataSource & Delegate
extension CountryDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getItemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as? CountryCell else { return UITableViewCell() }
        viewModel.configuarCell(cell, at: indexPath.item)
      return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}
