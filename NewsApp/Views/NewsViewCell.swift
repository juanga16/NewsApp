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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-dd HH:mm"
        publishedAtLabel.text = dateFormatter.string(from: new.publishedAt)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        container.addSubview(titleLabel)
        container.addSubview(publishedAtLabel)
        
        contentView.addSubview(container)
        
        container.snp.updateConstraints {
            (make) in
            make.left.equalTo(contentView)
            make.right.equalTo(contentView).offset(-20)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .left
        titleLabel.snp.updateConstraints {
            (make) in
            make.left.equalTo(container)
            make.right.equalTo(container)
            make.top.equalTo(container).offset(Constants.elementsTopMargin)
        }
        
        publishedAtLabel.textAlignment = .right
        publishedAtLabel.textColor = .black
        publishedAtLabel.snp.updateConstraints {
            (make) in
            make.left.equalTo(container)
            make.right.equalTo(container)
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.elementsTopMargin)
            make.bottom.equalTo(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
