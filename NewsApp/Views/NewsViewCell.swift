//
//  NewsViewsCell.swift
//  getYourNews
//
//  Created by Cosme Fulanito on 14/10/2019.
//  Copyright © 2019 Cosme Fulanito. All rights reserved.
//

import UIKit
import SwipeCellKit
import SnapKit

class NewsViewCell: SwipeTableViewCell {

    let container = UIView()
    let titleLabel = UILabel(frame: .zero)
    let publishedAtLabel = UILabel(frame: .zero)
    
    func configure(new: New) {
        titleLabel.text = new.title
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .justified
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-dd HH:mm"
        publishedAtLabel.text = dateFormatter.string(from: new.publishedAt)
        publishedAtLabel.textColor = .black
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        container.addSubview(titleLabel)
        container.addSubview(publishedAtLabel)
        
        contentView.addSubview(container)
        
        let elementsTopMargin = 10
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.snp.updateConstraints {
            (make) in
            make.left.equalTo(contentView)
            make.right.equalTo(contentView).offset(-20)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.snp.updateConstraints {
            (make) in
            make.left.equalTo(container)
            make.right.equalTo(container)
            make.top.equalTo(container).offset(elementsTopMargin)
        }
        
        publishedAtLabel.translatesAutoresizingMaskIntoConstraints = false
        publishedAtLabel.textAlignment = .right
        publishedAtLabel.snp.updateConstraints {
            (make) in
            make.left.equalTo(container)
            make.right.equalTo(container)
            make.top.equalTo(titleLabel.snp.bottom).offset(elementsTopMargin)
            make.bottom.equalTo(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
