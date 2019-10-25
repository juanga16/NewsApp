//
//  DetailsController.swift
//  getYourNews
//
//  Created by Cosme Fulanito on 14/10/2019.
//  Copyright © 2019 Cosme Fulanito. All rights reserved.
//

import UIKit

class DetailsController: UIViewController {
    var newToShow: New?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var publishedAtLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    @IBAction func backButtonWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let new = newToShow {
            titleLabel.text = new.title
            authorLabel.text = "By " + new.author
            descriptionLabel.text = new.description
            
            if new.urlToImage != "" {
                loadImage(urlToImage: new.urlToImage)
            } else {
                imageView.isHidden = true
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM-dd HH:mm"
            publishedAtLabel.text = dateFormatter.string(from: new.publishedAt)
            
            contentLabel.text = new.content
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
            self.imageView.image = image
        }
    }
}
