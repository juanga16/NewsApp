//
//  DetailsController.swift
//  getYourNews
//
//  Created by Cosme Fulanito on 14/10/2019.
//  Copyright © 2019 Cosme Fulanito. All rights reserved.
//

import UIKit
import SnapKit

class DetailsController: UIViewController {
    var newToShow: New?
    
    let titleLabel = UILabel(frame: .zero)
    let descriptionLabel = UILabel(frame: .zero)
    let authorLabel = UILabel(frame: .zero)
    let publishedAtLabel = UILabel(frame: .zero)
    let imageView = UIImageView(frame: .zero)
    let contentLabel = UILabel(frame: .zero)
    
    override func viewDidLoad() {
        if let new = newToShow {
            view = UIView()
            view.backgroundColor = .systemBackground
            
            view.addSubview(titleLabel)
            view.addSubview(descriptionLabel)
            view.addSubview(authorLabel)
            view.addSubview(publishedAtLabel)
            view.addSubview(imageView)
            view.addSubview(contentLabel)
            
            // Title label
            titleLabel.text = new.title
            titleLabel.textColor = .label
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .justified
            titleLabel.snp.updateConstraints {
                (make) in
                make.left.equalTo(view).offset(Constants.elementsLeft)
                make.right.equalTo(view).offset(-Constants.elementsLeft)
                make.top.equalTo(Constants.fixedTopMargin)
            }
            
            // Description label
            descriptionLabel.text = new.description
            descriptionLabel.textAlignment = .justified
            descriptionLabel.font = UIFont.italicSystemFont(ofSize: 17)
            descriptionLabel.textColor = .label
            descriptionLabel.numberOfLines = 0
            descriptionLabel.snp.updateConstraints {
                (make) in
                make.left.equalTo(view).offset(Constants.elementsLeft)
                make.right.equalTo(view).offset(-Constants.elementsLeft)
                make.top.equalTo(titleLabel.snp.bottom).offset(Constants.elementsTopMargin)
            }
            
            // Author label
            authorLabel.text = new.author
            authorLabel.lineBreakMode = .byTruncatingTail
            authorLabel.snp.updateConstraints {
                (make) in
                make.left.equalTo(view).offset(Constants.elementsLeft)
                make.top.equalTo(descriptionLabel.snp.bottom).offset(Constants.elementsTopMargin)
                make.width.lessThanOrEqualTo(250)
            }
            
            // Published at label
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM-dd HH:mm"
            publishedAtLabel.text = dateFormatter.string(from: new.publishedAt)
            publishedAtLabel.textAlignment = .right
            publishedAtLabel.snp.updateConstraints {
                (make) in
                make.right.equalTo(view).offset(-Constants.elementsLeft)
                make.top.equalTo(authorLabel.snp.top)
            }
            
            // Image view
            imageView.isHidden = true
            imageView.contentMode = .scaleAspectFit
            imageView.snp.updateConstraints {
                (make) in
                make.left.equalTo(view).offset(Constants.elementsLeft)
                make.right.equalTo(view).offset(-Constants.elementsLeft)
                make.width.equalTo(view).offset(-Constants.elementsLeft*2)
                make.height.equalTo(0)
                make.top.equalTo(publishedAtLabel.snp.bottom).offset(Constants.elementsTopMargin)
            }
            
            if new.urlToImage != "" {
                loadImage(urlToImage: new.urlToImage)
            }
            
            // Content label
            contentLabel.text = new.content
            contentLabel.numberOfLines = 0
            contentLabel.textAlignment = .justified
            contentLabel.snp.updateConstraints {
                (make) in
                make.left.equalTo(view).offset(Constants.elementsLeft)
                make.right.equalTo(view).offset(-Constants.elementsLeft)
                make.top.equalTo(imageView.snp.bottom).offset(Constants.elementsTopMargin)
            }
        }
    }
}

extension DetailsController {
    
    func loadImage(urlToImage: String) {
        guard let imageUrl = URL(string: urlToImage) else {
            return
        }
        
        let cache = URLCache.shared
        let request = URLRequest(url: imageUrl)
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                print("Loading Cached Image")
                self.showImage(image: image)
            } else {
                print("Downloading Image")
                URLSession.shared.dataTask(with: request) {
                    data, response, error in
                    
                    if error != nil {
                        return
                    }
                    
                    if let data = data, let image = UIImage(data: data) {
                        let cachedData = CachedURLResponse(response: response!, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        
                        self.showImage(image: image)
                    }
                }.resume()
            }
        }
    }
    
    func showImage(image: UIImage) {
        DispatchQueue.main.async() {
            let widthRelation = image.size.width / self.imageView.frame.width
            let imageHeight = image.size.height / widthRelation
            
            self.imageView.image = image
            self.imageView.isHidden = false
            self.imageView.snp.updateConstraints {
                (make) in
                make.height.equalTo(imageHeight)
            }
            self.imageView.backgroundColor = .yellow
        }
    }
}
