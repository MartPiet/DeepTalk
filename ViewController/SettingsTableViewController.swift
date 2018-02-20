//
//  SettingsTableViewController.swift
//  DeepTalk
//
//  Created by Martin Pietrowski on 19.01.18.
//  Copyright © 2018 devpie. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    lazy var dataManager = DataManager()
    lazy var categories = dataManager.getCategories(all: true)
    lazy var enabledCategories = dataManager.getCategories(all: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as? SettingsTableViewCell else {
            fatalError("Wrong class for cell identifier \"settingsCell\".")
        }

        let tmpCategory = categories[indexPath.row]
        let enabled = enabledCategories.contains(tmpCategory)

        cell.setup(category: tmpCategory, enabled: enabled, dataManager: dataManager)
        
        return cell
    }
}
