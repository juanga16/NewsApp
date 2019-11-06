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
    let titleLabel : UILabel = {
        let tempTitleLabel = UILabel(frame: .zero)
        tempTitleLabel.numberOfLines = 5
        tempTitleLabel.textColor = .label
        tempTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        tempTitleLabel.textAlignment = .left
        return tempTitleLabel
    }()
    
    let publishedAtLabel : UILabel = {
        let tempPublishedAtLabel = UILabel(frame: .zero)
        tempPublishedAtLabel.textAlignment = .right
        tempPublishedAtLabel.textColor = .label
        return tempPublishedAtLabel
    }()
    
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
        
        container.snp.makeConstraints {
            make in
            make.left.equalTo(contentView)
            make.right.equalTo(contentView).offset(-20)
            make.top.bottom.equalTo(contentView)
        }
        
        titleLabel.snp.makeConstraints {
            make in
            make.left.right.equalTo(container)
            make.top.equalTo(container).offset(Constants.elementsTopMargin)
        }
        
        publishedAtLabel.snp.makeConstraints {
            make in
            make.left.right.equalTo(container)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
