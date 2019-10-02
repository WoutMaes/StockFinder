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

    //MARK: - Variables
    
    var searchController: UISearchController!
    var companyArray : [String] = [] //Bevat de lijst met bedrijven van searchStock
    
    let Alphavantage_APIKey : String  = "AIzaSyDJasa57Fp38ZVrg_oQ9ij6FTNiaAMLlyU"
    let AlphaVantage_URL : String = "https://www.alphavantage.co/query?"

    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        searchStock(searchKeyWord: "Apple")
    }
    
    //MARK: Request Search Endpoint to find a specific Stock
    
    func searchStock(searchKeyWord : String) {

        let params : [String : String] = [
            "function" : "SYMBOL_SEARCH",
            "keywords" : searchKeyWord,
            "apikey" : Alphavantage_APIKey
        ]
        
        Alamofire.request(AlphaVantage_URL, method: .get, parameters : params).responseJSON { (response) in
            if response.result.isSuccess {
                let companyResultJSON : JSON = JSON(response.result.value!) //Value mag hier altijd uitgepakt worden, want je weet dat er een antwoord is, want isSuccess is hier true
                for i in 0..<companyResultJSON["bestMatches"].count {
                    let companyName = companyResultJSON["bestMatches"][i]["1. symbol"].stringValue
                    self.companyArray.append(companyName)
                }
                self.tableView.reloadData()
            }
        }

    }

    //MARK: Networking with Alamofire
//
//    func requestOverNetwork(parameters : Parameters) -> DataRequest {
//        return Alamofire.request(AlphaVantage_URL, method: .get, parameters : parameters).responseJSON { (response) in
//            if response.result.isSuccess {
//                let companyResultJSON : JSON = JSON(response.result.value!) //Value mag hier altijd uitgepakt worden, want je weet dat er een antwoord is, want isSuccess is hiet true
//
//                print(companyResultJSON)
//            }
//        }
//    }
    
    
    //MARK: - UITableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockName", for: indexPath)
        
        cell.textLabel?.text = companyArray[indexPath.row]
                
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companyArray.count
    }


    //MARK: - UITableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let DetailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        
        DetailViewController?.name = companyArray[indexPath.row]
        
        self.navigationController?.pushViewController(DetailViewController!, animated: true)
        
        //Stap 3. Hier moet je als er op een rij geclickd wordt de info krijgen van het bedrijf op een andere viewController. Dus er moet een nieuw scherm gemaakt worden in Main.Storyboard
    }
    
}


    //MARK: - Extensions

extension SecondViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchStock(searchKeyWord: searchBar.text!)
        
        companyArray = []
        //Stap 2. Hier zou de tableView moeten worden geupdated met alle voorgestelde bedrijven die je krijgt van searchStock
    }
}

