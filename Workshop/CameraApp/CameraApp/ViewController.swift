//
//  ViewController.swift
//  CameraApp
//
//  Created by Agit on 24/10/2018.
//  Copyright © 2018 Agit. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet weak var imageName: UILabel!
    
    @IBOutlet weak var chooseImageButton: UIButton! {
        didSet{
            chooseImageButton.setTitle("Choose Image", for: UIControl.State.normal)
            chooseImageButton.backgroundColor = UIColor.black
        }
    }
    
    var image : UIImage? {
        didSet{

            if(image != nil)
            {
                // Set the image view
                imageView.contentMode = .scaleToFill
                imageView.image = image
                
                // Get label 
                if let pixelBuffer = image!.toCVPixelBuffer() {
                    do{
                        try imageName.text = getLabelName(image: pixelBuffer)
                    }
                    catch {
                        print("oh")
                    }
                }
            }
        }
    }
    
    //model
    let model = ImageClassifier()
    
    private func getLabelName(image : CVPixelBuffer) throws -> String{
        let prediction = try model.prediction(image: image)
        print(prediction.classLabelProbs[prediction.classLabel]! * 100) //prediction value
        return prediction.classLabel
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageName.text = "Thinking"
            image = pickedImage
        }
         picker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func choosePhotoFromGallery(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}


/* credits to https://gist.github.com/francoismarceau29/abac55c22f6e440800d1d73d72bf2225 */
extension UIImage {
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess else {
            return nil
        }
        
        if let pixelBuffer = pixelBuffer {
            CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)
            
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
            
            context?.translateBy(x: 0, y: self.size.height)
            context?.scaleBy(x: 1.0, y: -1.0)
            
            UIGraphicsPushContext(context!)
            self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            UIGraphicsPopContext()
            CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            
            return pixelBuffer
        }
        
        return nil
    }
}
