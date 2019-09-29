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

    
    //MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    //MARK: - Variables
    
    let wikipediaURl : String = "https://en.wikipedia.org/w/api.php"
    let imagePicker = UIImagePickerController()
    
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
    }
    
    //    func prefersStatusBarHidden() -> Bool {
    //        return true
    //    }
    
    //MARK: Set the imagePicker
    
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
    
    
    //MARK: Tap the camera
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    //MARK: Detect the Selected Image
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
    
    
    //MARK: Networking with Alamofire

    func requestInfo(companyName: String) {
            
        let params : [String:String] = [
        "format" : "json",
        "action" : "query",
        "prop" : "extracts",
        "exintro" : "",
        "explaintext" : "",
        "titles" : companyName.components(separatedBy: " ").first!,
        "indexpageids" : "",
        "redirects" : "1",
        ]
            
        Alamofire.request(wikipediaURl, method: .get, parameters: params).responseJSON { (response) in
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
}
