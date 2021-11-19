//
//  ViewController.swift
//  MLKit-Issue
//
//  Created by Billy on 11/19/21.
//

import UIKit
import MLKit

class ViewController: UIViewController {
    var detector: ObjectDetector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let localModel = LocalModel(path: Bundle.main.url(forResource: "red_model", withExtension: "tflite")!.relativePath)
        
        let options = CustomObjectDetectorOptions(localModel: localModel)
        options.detectorMode = .singleImage
        //options.shouldEnableClassification = true
        options.shouldEnableMultipleObjects = true
        options.classificationConfidenceThreshold = NSNumber(value: 0.0)
        options.maxPerObjectLabelCount = 3
        
        detector = ObjectDetector.objectDetector(options: options)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.recognizeObjects()
        }
    }

    func recognizeObjects() {
        let filePath = Bundle.main.path(forResource: "image", ofType: "jpg")
        let img = UIImage(contentsOfFile: filePath!)!
        let image = VisionImage(image: img)
        
        var objects: [Object]
        do {
          objects = try detector.results(in: image)
        } catch let error {
          print("Failed to detect object with error: \(error.localizedDescription).")
          return
        }
        print(objects)

        guard !objects.isEmpty else {
          print("Object detector returned no results.")
          return
        }
    }
}

