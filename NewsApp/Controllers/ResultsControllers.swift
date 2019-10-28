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
    
    let backButton = UIButton(frame: .zero)
    let newsRelatedToLabel = UILabel(frame: .zero)
    let termToSearchLabel = UILabel(frame: .zero)
    let loadingLabel = UILabel(frame: .zero)
    let tableView = UITableView(frame: .zero)
    
    override func viewDidLoad() {
        view = UIView()
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        view.addSubview(newsRelatedToLabel)
        view.addSubview(termToSearchLabel)
        view.addSubview(loadingLabel)
        view.addSubview(tableView)
        
        // Back button
        backButton.setTitle("< Back", for: .normal)
        backButton.setTitleColor(.blue, for: .normal)
        backButton.snp.updateConstraints {
            (make) in
            make.left.equalTo(view).offset(Constants.elementsLeft)
            make.top.equalTo(view).offset(Constants.elementsTopMargin + 50)
        }
        backButton.addTarget(self, action: #selector(backButtonWasPressed), for: .touchUpInside)
        
        // News related to label
        newsRelatedToLabel.text = "News related to:"
        newsRelatedToLabel.textColor = .black
        newsRelatedToLabel.snp.updateConstraints {
            (make) in
            make.left.equalTo(view).offset(Constants.elementsLeft)
            make.top.equalTo(backButton.snp.bottom).offset(Constants.elementsTopMargin)
        }
        
        // Term to search label
        termToSearchLabel.text = termToSearch
        termToSearchLabel.textColor = .black
        termToSearchLabel.font = UIFont.boldSystemFont(ofSize: 18)
        termToSearchLabel.snp.updateConstraints {
            (make) in
            make.left.equalTo(newsRelatedToLabel.snp.right).offset(10)
            make.top.equalTo(newsRelatedToLabel.snp.top)
        }
        
        // Loading label
        loadingLabel.text = "Loading ..."
        loadingLabel.textColor = .black
        loadingLabel.snp.updateConstraints {
            (make) in
            make.left.equalTo(view).offset(Constants.elementsLeft)
            make.top.equalTo(newsRelatedToLabel.snp.bottom).offset(Constants.elementsTopMargin)
        }
        
        // Table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
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

    @objc func backButtonWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
            
            deleteAction.image = UIImage(named: "delete")
            
            let viewDetailsAction = SwipeAction(style: .default, title: "View") {
                action, indexPath in
                
                self.viewDetails(index: indexPath.row)
            }
            
            viewDetailsAction.image = UIImage(named: "details")
            
            actions = [deleteAction, viewDetailsAction]
        } else {
            if let url = URL(string: news[indexPath.row].url) {
                let browseAction = SwipeAction(style: .default, title: "Browse") {
                    action, indexPath in
                    
                    UIApplication.shared.open(url)
                }
                
                browseAction.image = UIImage(named: "safari")
                
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
                        self.tableView.isHidden = false
                        
                        self.tableView.reloadData()
                    }
                } else {
                    self.loadingLabel.text = "No results"
                }
            }
        }
    }
    
    func viewDetails(index: Int) {
        let detailsController = DetailsController()
        let new = news[index]
            
        detailsController.newToShow = new
        self.present(detailsController, animated: true, completion: nil)
    }
}
