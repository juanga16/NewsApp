//
//  DetailsController.swift
//  NewsApp
//
//  Created by Cosme Fulanito on 14/10/2019.
//  Copyright © 2019 Cosme Fulanito. All rights reserved.
//

import UIKit
import SnapKit

class DetailsController: UIViewController {
    var newToShow : New?
    
    let operationQueue = OperationQueue()
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let titleLabel : UILabel = {
        let tempTitleLabel = UILabel(frame: .zero)
        tempTitleLabel.textColor = .label
        tempTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        tempTitleLabel.numberOfLines = 0
        tempTitleLabel.textAlignment = .justified
        return tempTitleLabel
    }()
    
    let descriptionLabel : UILabel = {
        let tempDescriptionLabel = UILabel(frame: .zero)
        tempDescriptionLabel.textAlignment = .justified
        tempDescriptionLabel.font = UIFont.italicSystemFont(ofSize: 17)
        tempDescriptionLabel.textColor = .label
        tempDescriptionLabel.numberOfLines = 0
        return tempDescriptionLabel
    }()
    
    let authorLabel : UILabel = {
        let tempAuthorLabel = UILabel(frame: .zero)
        tempAuthorLabel.lineBreakMode = .byTruncatingTail
        tempAuthorLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return tempAuthorLabel
    }()
    
    let publishedAtLabel : UILabel = {
        let tempPublishedAtLabel = UILabel(frame: .zero)
        tempPublishedAtLabel.textAlignment = .right
        return tempPublishedAtLabel
    }()
    
    let imageView : UIImageView = {
        let tempImageView = UIImageView(frame: .zero)
        tempImageView.isHidden = true
        tempImageView.contentMode = .scaleAspectFit
        return tempImageView
    }()
    
    let contentLabel : UILabel = {
        let tempContentLabel = UILabel(frame: .zero)
        tempContentLabel.numberOfLines = 0
        tempContentLabel.textAlignment = .justified
        return tempContentLabel
    }()
    
    override func viewDidLoad() {
        view = UIView(frame: .zero)
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(containerView)
        
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(authorLabel)
        containerView.addSubview(publishedAtLabel)
        containerView.addSubview(contentLabel)
        
        // Scroll view
        scrollView.snp.updateConstraints {
            make in
            make.edges.equalTo(view)
        }
        
        // Container view
        containerView.snp.updateConstraints {
            make in
            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view)
            make.width.height.equalTo(scrollView)
        }
        
        // Image view
        imageView.snp.updateConstraints {
            make in
            make.left.right.equalTo(view)
            make.top.equalTo(10)
            make.height.equalTo(0)
        }
        
        guard let urlToImage = newToShow?.urlToImage, urlToImage != "" else {
            updateRestOfElements()
            return
        }
        
        loadImage(urlToImage)
    }
}

extension DetailsController {
    
    func loadImage(_ urlToImage: String) {
        guard let imageUrl = URL(string: urlToImage) else {
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            [unowned self] in
            let cache = URLCache()
            let request = URLRequest(url: imageUrl)
                
            if let cachedData = cache.cachedResponse(for: request), let image = UIImage(data: cachedData.data) {
                print("Loading Cached Image")
                self.showImage(image: image)
            } else {
             
                print("Downloading Image")
                
                let session = URLSession(configuration: .ephemeral)
                let task = session.dataTask(with: request, completionHandler: {
                    data, response, error in
                   
                    if let data = data, let image = UIImage(data: data), let response = response {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        
                        self.showImage(image: image)
                    }
                })
                task.resume()
                session.finishTasksAndInvalidate()
            }
        }
    }
    
    func showImage(image: UIImage) {
        DispatchQueue.main.async {
            let widthRelation = image.size.width / self.imageView.frame.width
            let imageHeight = image.size.height / widthRelation
            
            self.imageView.image = image
            self.imageView.isHidden = false
            self.imageView.snp.updateConstraints {
                (make) in
                make.height.equalTo(imageHeight)
            }
            
            self.updateRestOfElements()
        }
    }
    
    func updateRestOfElements() {
        guard let new = newToShow else { return }
        
        // Title label
        titleLabel.text = new.title
        titleLabel.snp.updateConstraints {
            make in
            make.left.equalTo(view).offset(Constants.elementsLeft)
            make.right.equalTo(view).offset(-Constants.elementsLeft)
            make.top.equalTo(imageView.snp.bottom).offset(Constants.elementsTopMargin)
        }
        
        // Description label
        descriptionLabel.text = new.description
        descriptionLabel.snp.updateConstraints {
            make in
            make.left.equalTo(view).offset(Constants.elementsLeft)
            make.right.equalTo(view).offset(-Constants.elementsLeft)
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.elementsTopMargin)
        }
        
        // Author label
        authorLabel.text = new.author
        authorLabel.snp.updateConstraints {
            make in
            make.left.equalTo(view).offset(Constants.elementsLeft)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Constants.elementsTopMargin)
            make.width.lessThanOrEqualTo(220)
        }
        
        // Published at label
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-dd HH:mm"
        publishedAtLabel.text = dateFormatter.string(from: new.publishedAt)
        publishedAtLabel.snp.updateConstraints {
            make in
            make.right.equalTo(view).offset(-Constants.elementsLeft)
            make.top.equalTo(authorLabel.snp.top)
        }
        
        // Content label
        contentLabel.text = new.content
        contentLabel.snp.updateConstraints {
            make in
            make.left.equalTo(view).offset(Constants.elementsLeft)
            make.right.equalTo(view).offset(-Constants.elementsLeft)
            make.top.equalTo(publishedAtLabel.snp.bottom).offset(Constants.elementsTopMargin)
        }
    }
}
