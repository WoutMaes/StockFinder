//
//  SecondViewController.swift
//  LogoFinder
//
//  Created by woutmaes on 26/09/2019.
//  Copyright © 2019 woutmaes. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SecondViewController: UITableViewController {
    
    //MARK: - IBOutlets
    
    
    
    
    //MARK: - Variables
    
    var searchController: UISearchController!
    
    var originalDataSource: [String] = []
    var currentDataSource : [String] = []
    
    
    let Alphavantage_APIKey : String  = "AIzaSyDJasa57Fp38ZVrg_oQ9ij6FTNiaAMLlyU"
    let AlphaVantage_URL : String = "https://www.alphavantage.co/query?"


    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

//        requestStockInfo(companyTicker: "LHA.FRK")
//        searchStock(searchKeyWord: "Apple")
        

            
            // Do any additional setup after loading the view.
    }
    

    //MARK: Request Stockinfo over network with Alamofire

    func requestStockInfo(companyTicker: String) {

        let params : [String : String] = [
            "function" : "TIME_SERIES_INTRADAY",
            "symbol" : companyTicker,
            "interval" : "60min",
            "outputsize" : "compact",
            "apikey" : Alphavantage_APIKey
        ]

        let requestStockInfoResult = requestOverNetwork(parameters: params)
        print(requestStockInfoResult)

    }
    
    //MARK: Request Search Endpoint to find a specific Stock
    
    func searchStock(searchKeyWord : String) {

        let params : [String : String] = [
            "function" : "SYMBOL_SEARCH",
            "keywords" : searchKeyWord,
            "apikey" : Alphavantage_APIKey
        ]
        
        let searchStockResult = requestOverNetwork(parameters: params)
        print(searchStockResult)

    }

    //MARK: Networking with Alamofire
    
    func requestOverNetwork(parameters : Parameters) -> DataRequest {
        return Alamofire.request(AlphaVantage_URL, method: .get, parameters : parameters).responseJSON { (response) in
            if response.result.isSuccess {
                let companyResultJSON : JSON = JSON(response.result.value!) //Value mag hier altijd uitgepakt worden, want je weet dat er een antwoord is, want isSuccess is hiet true
                
                print(companyResultJSON)
            }
        }
    }
}

    //MARK: - Extensions

extension SecondViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
    }
}

extension SecondViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchStock(searchKeyWord: searchBar.text!)
        
    }
}
