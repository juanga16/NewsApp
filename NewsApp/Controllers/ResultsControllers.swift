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
    
    let newsRelatedToLabel : UILabel = {
        let tempNewsRelatedToLabel = UILabel(frame: .zero)
        tempNewsRelatedToLabel.text = "News related to:"
        tempNewsRelatedToLabel.textColor = .label
        tempNewsRelatedToLabel.font = UIFont.systemFont(ofSize: 20)
        return tempNewsRelatedToLabel
    }()
    
    let termToSearchLabel : UILabel = {
        let tempTermToSearchLabel = UILabel(frame: .zero)
        tempTermToSearchLabel.textColor = .label
        tempTermToSearchLabel.font = UIFont.boldSystemFont(ofSize: 22)
        return tempTermToSearchLabel
    }()
    
    let tableView : UITableView = {
        let tempTableView = UITableView(frame: .zero)
        tempTableView.rowHeight = UITableView.automaticDimension
        tempTableView.isHidden = true
        tempTableView.separatorStyle = .singleLine
        tempTableView.separatorColor = .secondaryLabel
        tempTableView.separatorInset = .zero
        tempTableView.register(NewsViewCell.self, forCellReuseIdentifier: "newsViewCell")
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
        
        centeredView.addSubview(newsRelatedToLabel)
        centeredView.addSubview(termToSearchLabel)
       
        // Centered view
        centeredView.snp.makeConstraints {
            make in
            make.left.equalTo(view).offset(Constants.elementsLeft)
            make.top.equalTo(Constants.fixedTopMargin)
        }

        // News related to label
        newsRelatedToLabel.snp.makeConstraints {
            make in
            make.centerY.left.equalToSuperview()
        }
        
        // Term to search label
        termToSearchLabel.text = termToSearch
        termToSearchLabel.snp.makeConstraints {
            make in
            make.left.equalTo(newsRelatedToLabel.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        // Table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints {
            make in
            make.left.equalTo(view).offset(Constants.elementsLeft)
            make.top.equalTo(newsRelatedToLabel.snp.bottom).offset(Constants.elementsTopMargin)
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
            
            deleteAction.image = UIImage(systemName: "trash.fill")!.withTintColor(.white)
            
            let viewDetailsAction = SwipeAction(style: .default, title: "View") {
                action, indexPath in
                
                self.viewDetails(index: indexPath.row)
            }
            
            viewDetailsAction.image = UIImage(systemName: "viewfinder.circle.fill")!.withTintColor(.white)
            viewDetailsAction.textColor = .white
            viewDetailsAction.backgroundColor = .orange

            actions = [deleteAction, viewDetailsAction]
        } else {
            if let url = URL(string: news[indexPath.row].url) {
                let browseAction = SwipeAction(style: .default, title: "Browse") {
                    action, indexPath in
                    
                    UIApplication.shared.open(url)
                }
                
                browseAction.image = UIImage(systemName: "safari.fill")?.withTintColor(.white)
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
                        self.activityIndicator.stopAnimating()
                        self.centeredView.isHidden = false
                        self.tableView.isHidden = false
                        
                        self.tableView.reloadData()
                    }
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
