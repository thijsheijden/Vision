//
//  ViewController.swift
//  VisionApp
//
//  Created by Thijs van der Heijden on 11/3/17.
//  Copyright © 2017 Thijs van der Heijden. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }
    
    //function to chose an image from your library or take one with your camera
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.image = userPickedImage
            
            //transform the image from UIImage to a CIIMage type
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Whoops that sucks ass")
            }
            
            //call the detect function to pass the new ciImage into the network
            detect(image: ciImage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    //function to classify the image that is taken with the camera or chosen from the library
    func detect(image: CIImage) {
        
        //try to load the model, if not throw an error
        guard let model = try? VNCoreMLModel(for: chars74k().model) else {
            fatalError("Loading coreML model failed")
        }
        
        //send a request to the network to identify the image
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to load image")
        }
        
            print(results)

            //checking the results from the network
//            if let firstResult = results.first {
//                if firstResult.identifier.contains("hotdog") {
//                    self.navigationItem.title = "Hotdog!"
//                } else {
//                    self.navigationItem.title = "Not Hotdog!"
//                }
//            }
    }
        //create handler for image
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
            try handler.perform([request])
        }
        catch {
            print(error)
        }
        
        
}
    //if camera button in navbar pressed
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }

}

