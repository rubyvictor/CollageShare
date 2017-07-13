//
//  ViewController.swift
//  CollageShare
//
//  Created by Victor Lee on 13/7/17.
//  Copyright © 2017 VictorLee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIDropInteractionDelegate, UIDragInteractionDelegate {
    
    // Implement methods that conform to UIDragInteractionDelegate
    // This enables us to drag images from our app
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        
        let touchedPoint = session.location(in: self.view)
        if let touchedImageView = self.view.hitTest(touchedPoint, with: nil) as? UIImageView {
            let touchedImage = touchedImageView.image
            
            
        }
//        let itemProvider = NSItemProvider(object: <#T##NSItemProviderWriting#>)
//        let dragItem = UIDragItem(itemProvider: <#T##NSItemProvider#>)
        
        return []
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Conform interaction to UIDropInteractionDelegate
        view.addInteraction(UIDropInteraction(delegate: self))
        view.addInteraction(UIDragInteraction(delegate: self))
    }
    
    // Implement 3 methods
    
    // 3 To consume the image dropped into our app, must create view and frame to contain it
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        for dragItem in session.items {
            dragItem.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (obj, error) in
                if let error = error {
                    print("Failed to load our dragged item", error)
                    return
                }
                guard let draggedImage = obj as? UIImage else { return }
                
                // Get back onto main thread
                DispatchQueue.main.async {
                    let imageView = UIImageView(image: draggedImage)
                    imageView.isUserInteractionEnabled = true
                    self.view.addSubview(imageView)
                    
                    imageView.frame = CGRect(x: 0, y: 0, width: draggedImage.size.width, height: draggedImage.size.height)
                    
                    // Land image on location of mouse point
                    let centrePoint = session.location(in: self.view)
                    imageView.center = centrePoint
                }
            })
        }
    }
    
    // 2 Use copy for UIDropOperation
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    
    // 1 Set load UIImage as true
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    


}

