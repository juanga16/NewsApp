//
//  HistoricalSearchViewCell.swift
//  NewsApp
//
//  Created by Cosme Fulanito on 13/11/2019.
//  Copyright © 2019 Cosme Fulanito. All rights reserved.
//

import UIKit
import SwipeCellKit
import SnapKit

class HistoricalSearchViewCell: SwipeTableViewCell {

    let container = UIView()
    let termLabel : UILabel = {
        let tempTermLabel = UILabel(frame: .zero)
        tempTermLabel.textColor = .label
        tempTermLabel.font = UIFont.boldSystemFont(ofSize: 18)
        tempTermLabel.textAlignment = .left
        return tempTermLabel
    }()
    
    let resultsLabel : UILabel = {
        let tempResultsLabel = UILabel(frame: .zero)
        tempResultsLabel.textAlignment = .right
        tempResultsLabel.textColor = .label
        tempResultsLabel.font = UIFont.boldSystemFont(ofSize: 14)
        return tempResultsLabel
    }()

    let searchDateLabel : UILabel = {
        let tempSearchDateLabel = UILabel(frame: .zero)
        tempSearchDateLabel.textAlignment = .right
        tempSearchDateLabel.textColor = .label
        tempSearchDateLabel.font = UIFont.boldSystemFont(ofSize: 14)
        return tempSearchDateLabel
    }()
    
    func configure(historicalSearch: HistoricalSearch) {
        termLabel.text = historicalSearch.term
        
        resultsLabel.text = "\(historicalSearch.results) results"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        searchDateLabel.text = dateFormatter.string(from: historicalSearch.date!)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        container.addSubview(termLabel)
        container.addSubview(resultsLabel)
        container.addSubview(searchDateLabel)
        
        contentView.addSubview(container)
        
        container.snp.makeConstraints {
            make in
            make.left.equalTo(contentView)
            make.right.equalTo(contentView).offset(-20)
            make.top.bottom.equalTo(contentView)
        }
        
        termLabel.snp.makeConstraints {
            make in
            make.left.equalTo(container)
            make.top.equalTo(container).offset(Constants.elementsTopMargin)
        }
        
        resultsLabel.snp.makeConstraints {
            make in
            make.left.equalTo(container)
            make.top.equalTo(termLabel.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
            
        }

        searchDateLabel.snp.makeConstraints {
            make in
            make.left.right.equalTo(container)
            make.top.equalTo(termLabel.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
