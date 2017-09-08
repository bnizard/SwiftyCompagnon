//
//  SkillTableViewCell.swift
//  Swifty Companion
//
//  Created by Bastien NIZARD on 6/19/17.
//  Copyright © 2017 Bastien NIZARD. All rights reserved.
//

import UIKit

class SkillTableViewCell: UITableViewCell {

    @IBOutlet weak var SkillLabel: UILabel!
    
    @IBOutlet weak var LevelLabel: UILabel!
    
    var skill : NSDictionary? {
        didSet {
            if let s = skill {
                if let name = s["name"] as? String{
                    SkillLabel?.text = name
                }
                if let level = s["level"] as? Double{
                     LevelLabel?.text = String(describing: level)
                }
            }
        }
    }
}
