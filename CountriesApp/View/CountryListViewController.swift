//
//  CountryListViewController.swift
//  CountriesApp
//
//  Created by Mohamed Adel on 03/02/2024.
//

import UIKit

class CountryListViewController: UIViewController {

    // MARK: Vars
    var viewModel = CountryListViewModel()
    
    // MARK: Outlet
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        initView()
        initViewModel()
    }
    
    
    private func initView() {
        navigationItem.title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "CountryCell")
    }
    
    private func initViewModel() {
        viewModel.alertClosure = { [weak self] in
            if let message = self?.viewModel.alertMessage {
                self?.showAlert(message)
            }
        }
        
        viewModel.loadingIndicatorClosure = { [weak self] isLoading in
            if isLoading {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.viewDidLoad()
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}

// MARK: - DataSource & Delegate
extension CountryListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getItemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as? CountryCell else { return UITableViewCell() }
        viewModel.configuarCell(cell, at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell \(indexPath.row) selected")
        let vc = CountryDetailViewController()
        vc.country = viewModel.getselectedItem(at: indexPath.row)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
