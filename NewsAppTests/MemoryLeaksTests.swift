//
//  NewsAppTests.swift
//  NewsAppTests
//
//  Created by Cosme Fulanito on 06/11/2019.
//  Copyright © 2019 Cosme Fulanito. All rights reserved.
//

import Quick
import Nimble
import SpecLeaks

class MemoryLeaksTests: QuickSpec {
    override func spec() {
        describe("SearchControllerTest") {
            describe("viewDidLoad") {
                it("must no leak") {
                    let test = LeakTest {
                        return SearchController()
                    }
            
                    expect(test).toNot(leak())
                }
            }
        }
        
        describe("ResultshControllerTest") {
            describe("viewDidLoad") {
                it("must no leak") {
                    let test = LeakTest {
                        let resultsController = ResultsController()
                        resultsController.termToSearch = "Apple"
                        
                        return resultsController
                    }
            
                    expect(test).toNot(leak())
                }
            }
        }
        
        describe("DetailsControllerTest") {
            describe("viewDidLoad") {
                it("must no leak") {
                    let test = LeakTest {
                        let new = New()
                        new.author = "Christine Vasileva"
                        new.title = "Bakkt Records Second Highest Bitcoin Futures Volume Since Launch"
                        new.description = "Bakkt saw an overnight spike in Bitcoin futures trading volumes, despite the relatively sluggish price action. BTC’s trek to above the $9,400 mark inspired futures markets to gain activity. Bakkt Grows its Bitcoin Futures Activity Slowly The Bakkt Bitcoin fut…"
                        new.url = "https://bitcoinist.com/bakkt-bitcoin-futures-second-best-volume-day/"
                        new.urlToImage = "https://bitcoinist.com/wp-content/uploads/2019/11/6th-November-10-1920x1200.jpg"
                        new.publishedAt = Date()
                        new.content = "Bakkt saw an overnight spike in Bitcoin futures trading volumes, despite the relatively sluggish price action. BTC’s trek to above the $9,400 mark inspired futures markets to gain activity.\r\nBakkt Grows its Bitcoin Futures Activity Slowly\r\nThe Bakkt Bitcoin f… [+2607 chars]"
                        
                        let detailsController = DetailsController()
                        detailsController.newToShow = new
                        
                        return detailsController
                    }
                    
                    expect(test).toNot(leak())
                }
            }
        }
        
        describe("HistorialSearchesControllerTest") {
            describe("viewDidLoad") {
               it("must no leak") {
                   let test = LeakTest {
                       return HistoricalSearchesController()
                   }
           
                   expect(test).toNot(leak())
               }
            }
        }
    }
}
