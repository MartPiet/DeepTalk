//
//  ShareViewController.swift
//  DeepTalk
//
//  Created by Martin Pietrowski on 25.01.18.
//  Copyright © 2018 devpie. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        openShareMenu()
    }
    
    private func openShareMenu() {
        // text to share
        let text = "Mit dieser App kannst bedeutungsvolle Beziehungen aufbauen: \n https://itunes.apple.com/us/app/???"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop,
                                                         .copyToPasteboard,
                                                         .addToReadingList,
                                                         .assignToContact,
                                                         .openInIBooks,
                                                         .saveToCameraRoll,
                                                         UIActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),
                                                         UIActivityType(rawValue: "com.apple.mobilenotes.SharingExtension")
        ]
        
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
                self.increaseRecommendedCounter()
            }
        }
    }
    
    
    private func increaseRecommendedCounter() {
        let recommended = UserDefaults.standard.integer(forKey: "recommended")
        
        UserDefaults.standard.set(recommended + 1, forKey: "recommended")
    }
}
