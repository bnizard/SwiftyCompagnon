//
//  ProjectTableViewCell.swift
//  Swifty Companion
//
//  Created by Bastien NIZARD on 6/19/17.
//  Copyright © 2017 Bastien NIZARD. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

   
    @IBOutlet weak var ProjectLabel: UILabel!
    
    @IBOutlet weak var ProjectLevel: UILabel!
    
    var projet : NSDictionary? {
        didSet {
            if let p = projet {
                if let proj = p["project"] as! NSDictionary? {
                    if let name = proj["slug"] as! String? {
                        ProjectLabel?.text = name
                    }
                }
                if let final_mark = p["final_mark"] as Any?{
                    let res = String(describing: final_mark)
                    if res != "<null>" {
                        if (Int(res)! >= 50)
                        {
                            ProjectLevel?.textColor = UIColor.green
                        }
                        else
                        {
                            ProjectLevel?.textColor = UIColor.red
                        }
                        ProjectLevel?.text = res
                    }
                    else
                    {
                        ProjectLevel?.text = ""
                    }
                }
            }
        }
    }

}
