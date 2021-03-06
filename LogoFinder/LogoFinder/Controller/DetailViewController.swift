//
//  DetailViewController.swift
//  LogoFinder
//
//  Created by woutmaes on 02/10/2019.
//  Copyright © 2019 woutmaes. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailViewController: UITableViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var labelName: UILabel!
    
    //MARK: - Variables
    
    let Alphavantage_APIKey : String  = "AIzaSyDJasa57Fp38ZVrg_oQ9ij6FTNiaAMLlyU"
    let AlphaVantage_URL : String = "https://www.alphavantage.co/query?"
    
    var name = ""
    var company = ""
    
    var companyDetailArray : [String] = []
    var companyVolume : String = ""
    var companyHigh : String = ""
    var companyClose : String = ""
    var companyOpen : String = ""
    var companyLow : String = ""

    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelName.text = name
        if company != "" {
            searchStock(searchKeyWord: company)
        }
        if name != "" {
            requestStockInfo(companyTicker: name)
        }
    }
    
    
    //MARK: Request Search Endpoint to find a specific Stock
       
    func searchStock(searchKeyWord : String) {
        let params : [String : String] = [
            "function" : "SYMBOL_SEARCH",
            "keywords" : searchKeyWord.components(separatedBy: " ").first!,
            "apikey" : Alphavantage_APIKey
        ]
        
        Alamofire.request(AlphaVantage_URL, method: .get, parameters : params).responseJSON { (response) in
            if response.result.isSuccess {
                let companyResultJSON : JSON = JSON(response.result.value!) //Value mag hier altijd uitgepakt worden, want je weet dat er een antwoord is, want isSuccess is hier true
                self.requestStockInfo(companyTicker: companyResultJSON["bestMatches"][0]["1. symbol"].stringValue)
                } else if response.result.isFailure {
                print("Error didn't get response of Alpha Vantage")
            }
        }
    }
    
    //MARK: Request Stockinfo over network with Alamofire

       func requestStockInfo(companyTicker: String) {
        
           let params : [String : String] = [
               "function" : "TIME_SERIES_DAILY",
               "symbol" : companyTicker,
               "outputsize" : "compact",
               "apikey" : Alphavantage_APIKey
           ]
           
           Alamofire.request(AlphaVantage_URL, method: .get, parameters : params).responseJSON { (response) in
               if response.result.isSuccess {
                
                let companyResultJSON : JSON = JSON(response.result.value!) //Value mag hier altijd uitgepakt worden, want je weet dat er een antwoord is, want isSuccess is hiet true
                   
                let latestRefresh = companyResultJSON["Meta Data"]["3. Last Refreshed"].stringValue.components(separatedBy: " ").first!
                
//                let latestRefresh = companyResultJSON["Meta Data"]["3. Last Refreshed"].stringValue
                
                self.companyOpen = companyResultJSON["Time Series (Daily)"][latestRefresh]["1. open"].stringValue
                self.companyHigh = companyResultJSON["Time Series (Daily)"][latestRefresh]["2. high"].stringValue
                self.companyLow = companyResultJSON["Time Series (Daily)"][latestRefresh]["3. low"].stringValue
                self.companyClose = companyResultJSON["Time Series (Daily)"][latestRefresh]["4. close"].stringValue
                self.companyVolume = companyResultJSON["Time Series (Daily)"][latestRefresh]["5. volume"].stringValue
                    
                self.companyDetailArray.append("Open:         " + self.companyOpen)
                self.companyDetailArray.append("High:         " + self.companyHigh)
                self.companyDetailArray.append("Low:          " + self.companyLow)
                self.companyDetailArray.append("Close:        " + self.companyClose)
                self.companyDetailArray.append("Volume:       " + self.companyVolume)
                print(self.companyDetailArray)
                self.tableView.reloadData()
               }
           }
       }
    
    //MARK: - UITableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockInfo", for: indexPath)
        
        cell.textLabel?.text = companyDetailArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companyDetailArray.count
    }
}
