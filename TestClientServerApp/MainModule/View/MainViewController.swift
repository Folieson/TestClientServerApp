//
//  MainViewController.swift
//  TestClientServerApp
//
//  Created by Андрей Понамарчук on 14.12.2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var presenter: MainPresenterProtocol!
    let cellId = "Cell"
    var currentPage = 1
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getItemsPage(pageNumb: currentPage)
        registerTable()
        self.setNavBar(title: "Computer database")
    }
    
    private func registerTable() {
        tableView.register( UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    private func setNavBar(title: String) {
        self.navigationItem.title = title
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRow = indexPath.row
        if lastRow == presenter.items.count - 1 {
            currentPage += 1
            presenter.getItemsPage(pageNumb: currentPage)
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let item = self.presenter.items[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.company?.name
        return cell
    }
}

extension MainViewController: MainViewProtocol {
    func success() {
        self.tableView.reloadData()
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
    func showActivityIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
            
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}

