//
//  DetailsControllerTests.swift
//  NewsAppTests
//
//  Created by Cosme Fulanito on 07/11/2019.
//  Copyright © 2019 Cosme Fulanito. All rights reserved.
//

import Quick
import Nimble

class DetailsControllerTests: QuickSpec {
    override func spec() {
        describe("DetailsControllerTest") {
            describe("viewDidLoad") {
                var detailsController: DetailsController!
                var new: New!
                
                beforeEach {
                    // Arrange
                    detailsController = DetailsController()
                    
                    let gregorianCalendar = Calendar(identifier: .gregorian)
                    let dateComponents = DateComponents(calendar: gregorianCalendar, year: 2016, month: 11, day: 2, hour: 7, minute: 45)
                    guard let date = gregorianCalendar.date(from: dateComponents) else { return }

                    new = New()
                    new.author = "An author"
                    new.title = "The title"
                    new.description = "The description"
                    new.url = "https://theurl.com"
                    new.publishedAt = date
                    new.content = "A content"
                    new.urlToImage = ""
                    
                    let window = UIWindow(frame: UIScreen.main.bounds)
                    window.rootViewController = UINavigationController(rootViewController: detailsController)
                    window.makeKeyAndVisible()
                    
                    // Act
                    detailsController.newToShow = new
                    detailsController.viewDidLoad()
                }
                
                it("mustLoadNewData") {
                    // Assert
                    expect(detailsController.authorLabel.text).to(equal(new.author))
                    expect(detailsController.titleLabel.text).to(equal(new.title))
                    expect(detailsController.descriptionLabel.text).to(equal(new.description))
                    expect(detailsController.publishedAtLabel.text).to(equal("Nov-02 07:45"))
                    expect(detailsController.contentLabel.text).to(equal(new.content))
                }
            }
        }
    }
}
