//
//  SearchController.swift
//  getYourNews
//
//  Created by Cosme Fulanito on 14/10/2019.
//  Copyright © 2019 Cosme Fulanito. All rights reserved.
//

import UIKit

class SearchController: UIViewController {
    @IBOutlet weak var termTextField: UITextField!
    
    @IBAction func searchButtonWasPressed(_ sender: Any) {
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
        
        if let resultsController = storyboard?.instantiateViewController(withIdentifier: "resultsController") as? ResultsController {
            
            resultsController.termToSearch = termTextField.text!
            present(resultsController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        termTextField.text = ""
        
        let defaults = UserDefaults.standard
        if let term = defaults.string(forKey: "term") {
            termTextField.text = term
        }
        
        termTextField.becomeFirstResponder()
    }
}
