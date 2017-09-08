//
//  ViewController.swift
//  Swifty Companion
//
//  Created by Bastien NIZARD on 6/8/17.
//  Copyright © 2017 Bastien NIZARD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let clientSecret = "357d8c1567f770af7231f03d495f3f08a7de30fee2f9e5fb4f9e82a4804a862"
    let clientUid = "27a63c34f5b3546accf98937afc2e800080a775826700c34ec51dc9b45fdc2c9"

    struct token {
        var value: String?
        var timeToDeath : Double?
        
        init()
        {
            value = nil
            timeToDeath = 0
        }
    }
       var requestToken = token()
    var client = User()
    
    @IBOutlet weak var SearchField: UITextField!
    
    @IBAction func SearchButton(_ sender: UIButton) {
        if (SearchField.text != "")
        {
            request42API()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background42.png")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func request42API()
    {
        getActualTokenOrRefresh()
    }
    
    func getActualTokenOrRefresh()
    {
        let timestamp = NSDate().timeIntervalSince1970
        
        if(self.requestToken.value == nil || self.requestToken.timeToDeath! < timestamp)
        {
            print("Request a new token")
            getRequestToken()
        }
        else
        {
            print("Get actual token")
            getRequestLogin(login: SearchField.text!)
        }
    }
    
    func getRequestToken() {
        //        from 42 getting started: https://api.intra.42.fr/apidoc/guides/getting_started
        let url = NSURL(string: "https://api.intra.42.fr/oauth/token")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        let HTTPBody: String = "grant_type=client_credentials" + "&" + "client_id=" + clientUid + "&" + "client_secret=" + clientSecret
        request.httpBody = HTTPBody.data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                print("get42APIToken error: \(error)")
                return
            }
            else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
//                        dic.forEach { print("\($0): \($1)") }
                        if let type = dic["token_type"] as? String {
                            if type == "bearer" {
                                if let tmp = dic["access_token"] as? String {
                                    self.requestToken.value = tmp
//                                    print("Token: " + self.requestToken.value!)
                                }
                            }
                        }
                        if let created_at = dic["created_at"] as? Double {
                            if let expire_in = dic["expires_in"] as? Double {
//                                print("created: " + created_at)
//                                print("expire: " + expire_in)
                                self.requestToken.timeToDeath = created_at + expire_in
//                                self.requestToken.timeToDeath = NSDate().timeIntervalSince1970 + 5
//                                print ("timeToDeath: \(self.requestToken.timeToDeath!)")
                            }
                        }

                    }
                }
                catch (let err) {
                    print("get42APIToken err: \(err)")
                    return
                }
                self.getRequestLogin(login: self.SearchField.text!)
            }
        }
        task.resume()
    }
    
    func getRequestLogin(login: String)
    {
        print("Token: \(requestToken.value!)")
        guard let url = NSURL(string: "https://api.intra.42.fr/v2/users/" + login.lowercased()) as NSURL? else
        {
            print("Bad format for login")
            return
        }
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer " + requestToken.value!, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        print("Request: \(request)")
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                print("getRequestLogin error: \(error)")
                return
            }
            else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
//                        dic.forEach { print("\($0): \($1)") }
                        print("------------------------------")
                        if let cursus_users = dic["cursus_users"] as? NSArray {
//                            cursus_users.forEach { print("\($0): \($1)") }
                            if cursus_users.count > 0, let lev = cursus_users[0] as? NSDictionary {
                                if let level = lev["level"] as? Double {
                                    print("Level: \(level)")
                                    self.client.niveau = level
                                }
                                if let skill = lev["skills"] as? NSArray {
//                                    print("skills:  \(skill)")
                                    self.client.skills = skill
                                }
                            }
                        }
                        
                        if let location = dic["location"] as? String {
                            self.client.location = location
                            print("location: \(location)")
                        }
                        if let img_url = dic["image_url"] as? String {
                            self.client.imageUrl = img_url
                            print("Imageurl: \(img_url)")
                        }
                        if let email = dic["email"] as? String {
                            self.client.email = email
                            print("Email: \(email)")
                        }
                        
                        if let login = dic["login"] as? String {
                            self.client.login = login
                            print("Login: \(login)")
                        }
                        
                        if let projets = dic["projects_users"] as? NSArray {
                            self.client.projets = projets
                            print("Projets: \(projets)")
                        }
            
                        if (dic.count != 0)
                        {
                            self.presentSecondView()
                        }
                        else
                        {
                            print("Login not found")
                        }
                    }
                }
                catch (let err) {
                    print("getRequestLogin err: \(err)")
                }
            }
        }
        task.resume()
    }
    
    func presentSecondView()
    {
        OperationQueue.main.addOperation {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
            vc.client = self.client
            self.present(vc, animated: false, completion: nil)
        }
    }
}

