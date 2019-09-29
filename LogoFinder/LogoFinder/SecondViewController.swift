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

class SecondViewController: UIViewController {
    
    let Alphavantage_APIKey : String  = "AIzaSyDJasa57Fp38ZVrg_oQ9ij6FTNiaAMLlyU"
    let AlphaVantage_URL : String = "https://www.alphavantage.co/query?"


    override func viewDidLoad() {
        super.viewDidLoad()

        requestInfo(companyTicker: "MELE.BR")
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Request info over network with Alamofire
    
    func requestInfo(companyTicker: String) {
        
        let params : [String : String] = [
            "function" : "TIME_SERIES_INTRADAY",
            "symbol" : companyTicker,
            "interval" : "60min",
            "outputsize" : "compact",
            "apikey" : Alphavantage_APIKey
        ]
        
        
        Alamofire.request(AlphaVantage_URL, method: .get, parameters: params).responseJSON { (response) in
            if response.result.isSuccess {
                let companyResultJSON : JSON = JSON(response.result.value!) //Value mag hier altijd uitgepakt worden, want je weet dat er een antwoord is, want isSuccess is hiet true
                
                print(companyResultJSON)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
