//
//  AboutViewController.swift
//  DeepTalk
//
//  Created by Martin Pietrowski on 19.01.18.
//  Copyright © 2018 devpie. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Kefa", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0), NSAttributedStringKey.foregroundColor : UIColor.white]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func feedbackButtonAction(_ sender: UIButton) {
        rateApp(appId: "id1340315372") { success in
            print("RateApp \(success)")
        }
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        openShareMenu()
    }
    
    @IBAction func suggestQuestionsButton(_ sender: UIButton) {
        emailFeedback()
    }
    
    private func emailFeedback() {
        let email = "talkdeeper@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    /**
     REDUNDANCY
     */
    private func openShareMenu() {
        // text to share
        let text = "Schau dir mal DeepTalk an. Mit dieser App kannst du interessante Gespräche mit deinen Freunden führen: \n https://itunes.apple.com/us/app/deeptalk/id1340315372"
        
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
    
    /**
     REDUNDANCY
     */
    private func increaseRecommendedCounter() {
        let recommended = UserDefaults.standard.integer(forKey: "recommended")
        
        UserDefaults.standard.set(recommended + 1, forKey: "recommended")
    }
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
