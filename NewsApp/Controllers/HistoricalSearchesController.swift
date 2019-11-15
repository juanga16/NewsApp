//
//  HistoricalSearchesController.swift
//  NewsApp
//
//  Created by Cosme Fulanito on 13/11/2019.
//  Copyright © 2019 Cosme Fulanito. All rights reserved.
//

import UIKit
import SnapKit
import SwipeCellKit

class HistoricalSearchesController : UIViewController {
    var historicalSearches: [HistoricalSearch] = []
    
    let titleLabel : UILabel = {
        let tempNewsRelatedToLabel = UILabel(frame: .zero)
        tempNewsRelatedToLabel.text = "Historical searches"
        tempNewsRelatedToLabel.textColor = .label
        tempNewsRelatedToLabel.font = UIFont.systemFont(ofSize: 20)
        return tempNewsRelatedToLabel
    }()
    
    let tableView : UITableView = {
        let tempTableView = UITableView(frame: .zero)
        tempTableView.rowHeight = UITableView.automaticDimension
        tempTableView.isHidden = true
        tempTableView.separatorStyle = .singleLine
        tempTableView.separatorColor = .secondaryLabel
        tempTableView.separatorInset = .zero
        tempTableView.register(HistoricalSearchViewCell.self, forCellReuseIdentifier: "historicalSearchViewCell")
        return tempTableView
    }()
    
    let activityIndicator : UIActivityIndicatorView = {
        let tempActivityIndicator = UIActivityIndicatorView(style: .large)
        tempActivityIndicator.color = .label
        tempActivityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        return tempActivityIndicator
    }()
    
    let centeredView : UIStackView = {
        var tempCenteredView = UIStackView(frame: .zero)
        tempCenteredView.distribution = .equalSpacing
        tempCenteredView.alignment = .leading
        tempCenteredView.axis = .horizontal
        tempCenteredView.isHidden = true
        return tempCenteredView
    }()
    
    override func viewDidLoad() {
        view = {
            let tempView = UIView()
            tempView.backgroundColor = .systemBackground
            return tempView
        }()
        
        view.addSubview(activityIndicator)
        view.addSubview(centeredView)
        view.addSubview(tableView)
        
        centeredView.addSubview(titleLabel)
        
        // Centered view
        centeredView.snp.makeConstraints {
            make in
            make.left.equalTo(view).offset(Constants.elementsLeft)
            make.top.equalTo(Constants.fixedTopMargin)
        }

        // News related to label
        titleLabel.snp.makeConstraints {
            make in
            make.centerY.left.equalToSuperview()
        }
        
        // Table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints {
            make in
            make.left.equalTo(view).offset(Constants.elementsLeft)
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.elementsTopMargin)
            make.right.equalTo(view).offset(-Constants.elementsLeft / 2)
            make.bottom.equalTo(view.snp.bottom).offset(-Constants.elementsTopMargin)
        }
        
        // Activity indicator
        activityIndicator.snp.makeConstraints {
            make in
            make.centerX.centerY.equalTo(view)
            make.height.width.equalTo(50)
        }
        
        // Get and display results
        activityIndicator.startAnimating()
        getHistoricalSearches()
    }
}

extension HistoricalSearchesController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historicalSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historicalSearchViewCell") as! HistoricalSearchViewCell
        let historicalSearch = historicalSearches[indexPath.row]
        
        cell.delegate = self
        cell.configure(historicalSearch: historicalSearch)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        restoreSearch(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        var actions: [SwipeAction] = []

        
        if orientation == .right {
            let deleteAction = SwipeAction(style: .destructive, title: "Remove") {
                action, indexPath in
                
                CoreDataManager.shared.deleteHistoricalSearch(historicalSearch: self.historicalSearches[indexPath.row])
                self.historicalSearches.remove(at: indexPath.row)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            deleteAction.image = UIImage(systemName: "trash.fill")!.withTintColor(.white)
            
            let viewDetailsAction = SwipeAction(style: .default, title: "View") {
                action, indexPath in
                
                self.restoreSearch(index: indexPath.row)
            }
            
            viewDetailsAction.image = UIImage(systemName: "viewfinder.circle.fill")!.withTintColor(.white)
            viewDetailsAction.textColor = .white
            viewDetailsAction.backgroundColor = .orange

            actions = [deleteAction, viewDetailsAction]
        }
        
        return actions
    }
}

extension HistoricalSearchesController {
    
    func getHistoricalSearches() {
        historicalSearches = CoreDataManager.shared.getHistoricalSearches()
        
        if historicalSearches.count > 0 {
            afterObtainedData()
        }
    }
    
    func afterObtainedData() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.centeredView.isHidden = false
            self.tableView.isHidden = false
        
            self.tableView.reloadData()
        }
    }
    
    func restoreSearch(index: Int) {
        // Save the term
        let historicalSearch = historicalSearches[index]
        let defaults = UserDefaults.standard
        defaults.set(historicalSearch.term, forKey: "term")
        
        let resultsController = ResultsController()
        resultsController.termToSearch = historicalSearch.term ?? ""
          
        self.navigationController?.pushViewController(resultsController, animated: true)
    }
}
