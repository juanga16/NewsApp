//
//  SearchController.swift
//  getYourNews
//
//  Created by Cosme Fulanito on 14/10/2019.
//  Copyright © 2019 Cosme Fulanito. All rights reserved.
//

import UIKit
import SnapKit

class SearchController: UIViewController {
    let newsFinderLabel : UILabel = {
        let tempNewsFinderLabel = UILabel(frame: .zero)
        tempNewsFinderLabel.text = "LATESTS NEWS"
        tempNewsFinderLabel.textColor = .label
        tempNewsFinderLabel.font = UIFont(name: "Georgia", size: 38)
        return tempNewsFinderLabel
    }()
    
    let enterTermLabel : UILabel = {
        let tempEnterTermLabel = UILabel(frame: .zero)
        tempEnterTermLabel.text = "Enter any word to find related news"
        tempEnterTermLabel.textColor = .label
        return tempEnterTermLabel
    }()
    
    let termTextField : UITextField = {
        let tempTermTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        tempTermTextField.text = ""
        tempTermTextField.layer.borderWidth = 1
        tempTermTextField.layer.cornerRadius = 4
        tempTermTextField.setLeftPaddingPoints(10)
        tempTermTextField.setRightPaddingPoints(10)
        return tempTermTextField
        
    }()
    
    let searchButton : UIButton = {
        let tempSearchButton = UIButton(frame: .zero)
        tempSearchButton.setTitle("Search", for: .normal)
        tempSearchButton.setTitleColor(UIColor(named: "buttonColor"), for: .normal)
        tempSearchButton.addTarget(self, action: #selector(searchButtonWasPressed), for: .touchUpInside)
        return tempSearchButton
    }()
    
    let centeredView : UIStackView = {
        let tempCenteredView = UIStackView(frame: .zero)
        tempCenteredView.distribution = .equalCentering
        tempCenteredView.alignment = .center
        tempCenteredView.axis = .horizontal
        return tempCenteredView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        newsFinderLabel.snp.updateConstraints {
            make in
            make.top.equalTo(100)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 2.0, delay: 0.3, options: [], animations: {
            [unowned self] in
            self.newsFinderLabel.snp.updateConstraints {
                make in
                make.top.equalTo(300)
            }
            self.view.layoutIfNeeded()
        })
    }
    
    override func viewDidLoad() {
        view = {
            let tempView = UIView()
            tempView.backgroundColor = .systemBackground
            return tempView
        }()
        
        view.addSubview(newsFinderLabel)
        view.addSubview(enterTermLabel)
        view.addSubview(centeredView)
        
        centeredView.addArrangedSubview(termTextField)
        centeredView.addArrangedSubview(searchButton)
        
        // News finder label
        newsFinderLabel.snp.makeConstraints {
            make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(300)
        }
        
        // Enter term label
        enterTermLabel.snp.makeConstraints {
            make in
            make.centerX.equalTo(view)
            make.top.equalTo(newsFinderLabel.snp.bottom).offset(50)
        }
        
        // Centered view
        centeredView.snp.makeConstraints {
            make in
            make.left.equalTo(view).offset(Constants.elementsLeft*2)
            make.right.equalTo(view).offset(-Constants.elementsLeft*2)
            make.top.equalTo(enterTermLabel.snp.top).offset(75)
        }
        
        // Term text field
        termTextField.snp.makeConstraints {
            make in
            make.width.equalTo(200)
            make.height.equalTo(34)
        }
        
        let defaults = UserDefaults.standard
        if let term = defaults.string(forKey: "term") {
            termTextField.text = term
        }
    
        termTextField.becomeFirstResponder()
    }
    
    @objc func searchButtonWasPressed(_ sender: Any) {
        if termTextField.text == "" {
            let alert = UIAlertController(title: "News Finder", message: "Please enter term to be searched", preferredStyle: .actionSheet)
            let acceptAction = UIAlertAction(title: "Accept", style: .cancel, handler: nil)
            alert.addAction(acceptAction)
            
            alert.view.layoutIfNeeded()
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        // Save the term
        let defaults = UserDefaults.standard
        defaults.set(termTextField.text, forKey: "term")
        
        let resultsController = ResultsController()
        resultsController.termToSearch = termTextField.text!
          
        self.navigationController?.pushViewController(resultsController, animated: true)
    }
}
