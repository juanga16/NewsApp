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

class ResultsController: UIViewController {
    var news: [New] = []
    var termToSearch: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var termToSearchLabel: UILabel!
    @IBOutlet weak var loadingLabel: UILabel!
    
    @IBAction func backButtonWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true

        termToSearchLabel.text = termToSearch
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
        
        let colorBlue = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        var foreColor = colorBlue
        
        if indexPath.row % 2 == 1 {
            foreColor = UIColor.black
        }
        
        cell.delegate = self
        cell.configure(new: new, foreColor: foreColor)
        
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
        if let detailsController = storyboard?.instantiateViewController(withIdentifier: "detailsController") as? DetailsController {
            let new = news[index]
            
            detailsController.newToShow = new
            self.present(detailsController, animated: true, completion: nil)
        }
    }
}
