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

class DetailViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var labelName: UILabel!
    
    //MARK: - Variables
    
    let Alphavantage_APIKey : String  = "AIzaSyDJasa57Fp38ZVrg_oQ9ij6FTNiaAMLlyU"
    let AlphaVantage_URL : String = "https://www.alphavantage.co/query?"
    
    var name = ""

    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelName.text = name
        requestStockInfo(companyTicker: name)
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
           
           Alamofire.request(AlphaVantage_URL, method: .get, parameters : params).responseJSON { (response) in
               if response.result.isSuccess {
                   let companyResultJSON : JSON = JSON(response.result.value!) //Value mag hier altijd uitgepakt worden, want je weet dat er een antwoord is, want isSuccess is hiet true
                   
                   print(companyResultJSON)
               }
           }
       }
}
