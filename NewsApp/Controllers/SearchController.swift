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
    let termTextField = UITextField(frame: .zero)
    let searchButton = UIButton(frame: .zero)
    
    override func viewDidLoad() {
        view = UIView()
        view.backgroundColor = .white
        
        view.addSubview(newsFinderLabel)
        view.addSubview(enterTermLabel)
        view.addSubview(termTextField)
        view.addSubview(searchButton)
        
        let elementsLeft = 30
        let elementsTopMargin = 30
        
        // News finder label
        newsFinderLabel.text = "Find news about you want"
        newsFinderLabel.textColor = .black
        newsFinderLabel.font = UIFont.systemFont(ofSize: 25)
        newsFinderLabel.snp.updateConstraints {
            (make) in
            make.left.equalTo(self.view).offset(elementsLeft)
            make.top.equalTo(self.view).offset(elementsTopMargin + 50)
        }
        
        // Enter term label
        enterTermLabel.text = "Enter a term"
        enterTermLabel.textColor = .black
        enterTermLabel.snp.updateConstraints {
            (make) in
            make.left.equalTo(self.view).offset(elementsLeft)
            make.top.equalTo(newsFinderLabel.snp.bottom).offset(elementsTopMargin)
        }
        
        // Term text field
        termTextField.text = ""
        termTextField.snp.updateConstraints {
            (make) in
            make.left.equalTo(self.view).offset(elementsLeft)
            make.top.equalTo(enterTermLabel.snp.bottom).offset(elementsTopMargin)
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
            make.left.equalTo(self.view).offset(elementsLeft)
            make.top.equalTo(termTextField.snp.bottom).offset(elementsTopMargin)
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
