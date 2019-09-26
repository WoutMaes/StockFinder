//
//  ThirdViewController.swift
//  LogoFinder
//
//  Created by woutmaes on 26/09/2019.
//  Copyright © 2019 woutmaes. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON

class ThirdViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                 fatalError("Error, didn't convert to CIImage!")
            }
            
            detect(companyImage: ciImage)
        
        imageView.image = userPickedImage
        
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func detect(companyImage : CIImage) {
        
        guard let model = try? VNCoreMLModel(for: CompanyClassifier().model) else {
            fatalError("Error, didn't import the coreMLModel")
        }
        
        let request = VNCoreMLRequest(model: model) {
            (request, error) in
            guard let companyClassification = request.results?.first as? VNClassificationObservation else {
                fatalError("Couldn't classify image.")
            }
                        
            self.navigationItem.title = companyClassification.identifier
            
            self.requestInfo(companyName: companyClassification.identifier)
        }
        
        let handler = VNImageRequestHandler(ciImage: companyImage)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
    }
    
    
        func requestInfo(companyName: String) {
            
            let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts",
            "exintro" : "",
            "explaintext" : "",
            "titles" : companyName.components(separatedBy: " ").first!,
            "indexpageids" : "",
            "redirects" : "1",
            ]
            
            Alamofire.request(wikipediaURl, method: .get, parameters: parameters).responseJSON { (response) in
                if response.result.isSuccess {
                    print("Received answer from Wikipedia")
                    print(response)
                    print(companyName.components(separatedBy: " ").first!)
                    let companyJSON : JSON = JSON(response.result.value!)
                    
                    let pageId = companyJSON["query"]["pageids"][0].stringValue
                    
                    let companyDescription = companyJSON["query"]["pages"][pageId]["extract"].stringValue
                    
                    self.label.text = companyDescription
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
