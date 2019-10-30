//
//  ResultsController.swift
//  getYourNews
//
//  Created by Cosme Fulanito on 14/10/2019.
//  Copyright © 2019 Cosme Fulanito. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwipeCellKit
import SnapKit

class ResultsController: UIViewController {
    var news: [New] = []
    var termToSearch: String = ""
    
    let newsRelatedToLabel = UILabel(frame: .zero)
    let termToSearchLabel = UILabel(frame: .zero)
    let loadingLabel = UILabel(frame: .zero)
    let tableView = UITableView(frame: .zero)
    
    override func viewDidLoad() {
        view = UIView()
        view.backgroundColor = .white
        
        view.addSubview(loadingLabel)
        view.addSubview(newsRelatedToLabel)
        view.addSubview(termToSearchLabel)
        view.addSubview(tableView)
        
        // Loading label
        loadingLabel.text = "LOADING ..."
        loadingLabel.font = UIFont(name: "Georgia", size: 30)
        loadingLabel.textColor = .black
        loadingLabel.snp.updateConstraints {
            (make) in
            make.left.equalTo(view).offset(Constants.elementsLeft)
            make.top.equalTo(Constants.fixedTopMargin)
        }
        // News related to label
        newsRelatedToLabel.text = "News related to:"
        newsRelatedToLabel.textColor = .black
        termToSearchLabel.font = UIFont.systemFont(ofSize: 20)
        newsRelatedToLabel.isHidden = true
        newsRelatedToLabel.snp.updateConstraints {
            (make) in
            make.left.equalTo(view).offset(Constants.elementsLeft)
            make.top.equalTo(Constants.fixedTopMargin)
        }
        
        // Term to search label
        termToSearchLabel.text = termToSearch
        termToSearchLabel.textColor = .black
        termToSearchLabel.font = UIFont.boldSystemFont(ofSize: 22)
        termToSearchLabel.isHidden = true
        termToSearchLabel.snp.updateConstraints {
            (make) in
            make.left.equalTo(newsRelatedToLabel.snp.right).offset(10)
            make.top.equalTo(newsRelatedToLabel.snp.top)
        }
        
        // Table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isHidden = true
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .blue
        tableView.separatorInset = .zero
        tableView.register(NewsViewCell.self, forCellReuseIdentifier: "newsViewCell")
        tableView.snp.updateConstraints {
            (make) in
            make.left.equalTo(view).offset(Constants.elementsLeft)
            make.top.equalTo(newsRelatedToLabel.snp.bottom).offset(Constants.elementsTopMargin)
            make.right.equalTo(view).offset(-Constants.elementsLeft)
            make.bottom.equalTo(view.snp.bottom).offset(-Constants.elementsTopMargin)
        }
        
        // Get and display results
        getNews()
    }
}

extension ResultsController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsViewCell") as! NewsViewCell
        let new = news[indexPath.row]
        
        cell.delegate = self
        cell.configure(new: new)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewDetails(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        var actions: [SwipeAction] = []
        
        if orientation == .right {
            let deleteAction = SwipeAction(style: .destructive, title: "Remove") {
                action, indexPath in
                
                self.news.remove(at: indexPath.row)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            deleteAction.image = UIImage(systemName: "trash.fill")
            
            let viewDetailsAction = SwipeAction(style: .default, title: "View") {
                action, indexPath in
                
                self.viewDetails(index: indexPath.row)
            }
            
            viewDetailsAction.image = UIImage(systemName: "viewfinder.circle.fill")
            viewDetailsAction.textColor = .white
            viewDetailsAction.backgroundColor = UIColor.orange

            actions = [deleteAction, viewDetailsAction]
        } else {
            if let url = URL(string: news[indexPath.row].url) {
                let browseAction = SwipeAction(style: .default, title: "Browse") {
                    action, indexPath in
                    
                    UIApplication.shared.open(url)
                }
                
                browseAction.image = UIImage(systemName: "safari.fill")
                browseAction.textColor = .white
                browseAction.backgroundColor = .systemBlue

                actions.append(browseAction)
            }
        }
        
        return actions
    }
}

extension ResultsController {
    
    func getNews() {
        let url = "https://newsapi.org/v2/everything?q=" + termToSearch + "&language=en&pageSize=30&sortBy=publishedAt&apiKey=47a45430a0464d54baef451246447424"
        
        Alamofire.request(url, method: .get).responseJSON {
            response in
            
            if response.result.isSuccess {
                let json: JSON = JSON(response.result.value!)
                
                for article in json["articles"].arrayValue {
                    let author = article["author"].stringValue
                    let title = article["title"].stringValue
                    let description = article["description"].stringValue
                    let url = article["url"].stringValue
                    let urlToImage = article["urlToImage"].stringValue
                    let publishedAt = article["publishedAt"].stringValue
                    let content = article["content"].stringValue
                    
                    let new = New.from(author, title: title, description: description, url: url, urlToImage: urlToImage, publishedAt: publishedAt, content: content)
                    
                    self.news.append(new)
                }
                
                if self.news.count > 0 {
                    DispatchQueue.main.async {
                        self.loadingLabel.isHidden = true
                        self.newsRelatedToLabel.isHidden = false
                        self.termToSearchLabel.isHidden = false
                        self.tableView.isHidden = false
                        
                        self.tableView.reloadData()
                    }
                } else {
                    self.loadingLabel.text = "NO RESULTS"
                }
            }
        }
    }
    
    func viewDetails(index: Int) {
        let detailsController = DetailsController()
        let new = news[index]
        detailsController.newToShow = new
        
        self.navigationController?.pushViewController(detailsController, animated: true)
    }
}
