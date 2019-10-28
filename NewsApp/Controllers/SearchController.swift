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
    let newsFinderLabel = UILabel(frame: .zero)
    let enterTermLabel =  UILabel(frame: .zero)
    let termTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
    let searchButton = UIButton(frame: .zero)
    
    override func viewDidLoad() {
        view = UIView()
        view.backgroundColor = .white
        
        view.addSubview(newsFinderLabel)
        view.addSubview(enterTermLabel)
        view.addSubview(termTextField)
        view.addSubview(searchButton)
        
        // News finder label
        newsFinderLabel.text = "NEWS OF THE WORLD"
        newsFinderLabel.textColor = .black
        newsFinderLabel.font = UIFont.systemFont(ofSize: 35)
        newsFinderLabel.snp.updateConstraints {
            (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(300)
        }
        
        // Enter term label
        enterTermLabel.text = "Enter any word to find related news"
        enterTermLabel.textColor = .black
        enterTermLabel.snp.updateConstraints {
            (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(newsFinderLabel.snp.bottom).offset(Constants.elementsTopMargin)
        }
        
        // Term text field
        termTextField.text = ""
        termTextField.layer.borderWidth = 1
        termTextField.layer.cornerRadius = 4
        termTextField.setLeftPaddingPoints(10)
        termTextField.setRightPaddingPoints(10)
        termTextField.snp.updateConstraints {
            (make) in
            make.left.equalTo(view).offset(Constants.elementsLeft)
            make.top.equalTo(enterTermLabel.snp.bottom).offset(Constants.elementsTopMargin)
            make.width.equalTo(200)
            make.height.equalTo(34)
        }
        
        let defaults = UserDefaults.standard
        if let term = defaults.string(forKey: "term") {
            termTextField.text = term
        }
    
        termTextField.becomeFirstResponder()
        
        // Search button
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(.blue, for: .normal)
        searchButton.snp.updateConstraints {
            (make) in
            make.right.equalTo(view).offset(-Constants.elementsLeft)
            make.top.equalTo(enterTermLabel.snp.bottom).offset(Constants.elementsTopMargin)
        }
        searchButton.addTarget(self, action: #selector(searchButtonWasPressed), for: .touchUpInside)
    }
    
    @objc func searchButtonWasPressed(_ sender: Any) {
        if termTextField.text == "" {
            let alert = UIAlertController(title: "News Finder", message: "Please enter term to be searched", preferredStyle: .actionSheet)
            let acceptAction = UIAlertAction(title: "Accept", style: .cancel, handler: nil)
            alert.addAction(acceptAction)
            
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        // Save the term
        let defaults = UserDefaults.standard
        defaults.set(termTextField.text, forKey: "term")
        
        let resultsController = ResultsController()
        resultsController.termToSearch = termTextField.text!
            
        present(resultsController, animated: true, completion: nil)
    }
}
