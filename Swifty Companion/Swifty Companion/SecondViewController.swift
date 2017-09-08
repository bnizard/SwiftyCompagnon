//
//  SecondViewController.swift
//  Swifty Companion
//
//  Created by Bastien NIZARD on 6/14/17.
//  Copyright © 2017 Bastien NIZARD. All rights reserved.
//
import UIKit
import Darwin

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var client : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background42.png")!)
        GetImgFromUrl()
        SetProgressBar()
        Userinfo()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var SkillTableView: UITableView!
    
    @IBOutlet weak var ProjectTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == SkillTableView)
        {
            return (client?.skills!.count)!
        }
        if (tableView == ProjectTableView)
        {
            return (client?.projets!.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == SkillTableView)
        {
            let cell = SkillTableView.dequeueReusableCell(withIdentifier: "SkillTable") as! SkillTableViewCell
            cell.skill = (client?.skills?[indexPath.row] as? NSDictionary)!
            return cell
        }
        if (tableView == ProjectTableView)
        {
            let cell = ProjectTableView.dequeueReusableCell(withIdentifier: "ProjetTableView") as! ProjectTableViewCell
            cell.projet = (client?.projets?[indexPath.row] as? NSDictionary)!
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableview: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 25
    }
    
    @IBAction func BackButton(_ sender: UIButton) {
        client?.refresh()
        dismiss(animated: false, completion: nil)
    }
    
    @IBOutlet weak var Image: UIImageView!
    
    @IBOutlet weak var ProgressBar: UIProgressView!
    
    @IBOutlet weak var LabelNiveau: UILabel!
    
    @IBOutlet weak var LoginLabel: UILabel!
    
    @IBOutlet weak var LocationLabel: UILabel!
    
    @IBOutlet weak var EmailLabel: UILabel!
    
    func GetImgFromUrl()
    {
        if (client?.imageUrl != nil)
        {
            let url = URL(string: (client?.imageUrl)!)
            if let data = try? Data(contentsOf: url!)
            {
                Image.image = UIImage(data: data)
            }
        }
    }
    
    func SetProgressBar()
    {
        let entier: Double = floor((client?.niveau)!)
        let decimal: Double = (client?.niveau)! - entier as Double
        
        ProgressBar.progress = Float(decimal)
        LabelNiveau.text = "Level \(Int(entier)) - \(Int(round(decimal * 100))) %"
    }
    
    func Userinfo()
    {
        if (client?.login != nil)
        {
           LoginLabel.text = "login: \((client?.login)!)"
        }
        else
        {
            LoginLabel.text = "login: unknown"
        }
        if (client?.location != nil)
        {
            LocationLabel.text = "location: \((client?.location)!)"
        }
        else
        {
            LocationLabel.text = "location: unavailable"
        }
        if (client?.email != nil)
        {
            EmailLabel.text = "email: \((client?.email)!)"
        }
        else
        {
            EmailLabel.text = "email: unavailable"
        }
    }
}
