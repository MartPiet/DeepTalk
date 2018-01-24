//
//  SettingsTableViewCell.swift
//  DeepTalk
//
//  Created by Martin Pietrowski on 19.01.18.
//  Copyright © 2018 devpie. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var cellTextLabel: UIView!
    @IBOutlet weak var cellSwitch: UISwitch!
    
    var dataManager: DataManager!
    var category: String!
    var enabled: Bool!
    
    func setup(category: String, enabled: Bool, dataManager: DataManager) {
        self.dataManager = dataManager
        self.category = category
        self.enabled = enabled
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func switchAction(_ sender: Any) {
        
        cellSwitch.isOn
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
