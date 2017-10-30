//
//  ViewController.swift
//  Plist
//
//  Created by Lucio Pham on 10/30/17.
//  Copyright © 2017 Lucio Pham. All rights reserved.
//

import UIKit

struct User {
  var name: String
  var dob: String
  var profileImage: UIImage? {
    return UIImage.init(named: "\(name)")
  }
  
  init(_ name: String, dob: String) {
    self.name = name
    self.dob = dob
  }
}


class ViewController: UIViewController {
  
  @IBOutlet weak var usersTableView: UITableView!
  
  fileprivate let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
  fileprivate let fileManager = FileManager.default
  
  fileprivate var users = [User]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    setupTableView()
    loadDataFromBundlePlist()
  }
  
  fileprivate func setupTableView() {
    usersTableView.dataSource = self
    usersTableView.delegate = self
    usersTableView.register(UINib.init(nibName: "UserProfileCell", bundle: nil), forCellReuseIdentifier: "UserProfileCell")
  }
  
  
  // Create plist
  
  // Load data from plist
  
  func loadDataFromBundlePlist() {
    
    let path = documentDirectory.appending("/UserData.plist")
    
    if !fileManager.fileExists(atPath: path) {
      if let bundleURL = Bundle.main.path(forResource: "UserData", ofType: "plist") {
        try? fileManager.copyItem(atPath: bundleURL, toPath: path)
        
        guard let plistData = try? Data.init(contentsOf: URL.init(fileURLWithPath: path)) else { return }
        
        guard let result = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [[String: String]] else { return }
        for userInformation in result! {
          let user = User.init(userInformation["userName"]!, dob: userInformation["dob"]!)
          users.append(user)
        }
      }
    } else {
      guard let plistData = try? Data.init(contentsOf: URL.init(fileURLWithPath: path)) else { return }
      
      guard let result = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [[String: String]] else { return }
      for userInformation in result! {
        let user = User.init(userInformation["userName"]!, dob: userInformation["dob"]!)
        users.append(user)
      }
    }
    
  }
  @IBAction func addMoreUser(_ sender: UIBarButtonItem) {
    insertDataIntoPlist()
    usersTableView.reloadData()
  }
  
  // Remove data from plist
  
  func removeDataFromPlist() {
    
  }
  
  // Insert data into plist
  
  func insertDataIntoPlist() {
    let path = documentDirectory.appending("/UserData.plist")
    
    let newUser = User.init("Lucio", dob: "15-5-1994")
    users.append(newUser)
    
    if fileManager.fileExists(atPath: path) {
      try? fileManager.removeItem(atPath: path)
      
      let newUserArray = NSArray.init(object: users)
      newUserArray.write(toFile: path, atomically: true)
    }
    
  }
  
  // Update data from plist
  
  func updateDataFromPlist() {
    
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let userProfileCell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath) as? UserProfileCell else { return UITableViewCell() }
    
    let user = users[indexPath.row]
    
    userProfileCell.user = user
    
    return userProfileCell
  }
}

extension ViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 65.0
  }
  
}
