//
//  TableViewController.swift
//  SpaceInvaders
//
//  Created by administrator on 24.03.2021.
//  Copyright © 2021 administrator. All rights reserved.
//

import Foundation

import CoreData
import UIKit

class ResultTableViewControler : UITableViewController{
    var results: [NSManagedObject] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")


    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      //1
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      //2
      let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "Result")
      
      //3
      do {
        results = try managedContext.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resultData = results[indexPath.row]
        let cell =
          tableView.dequeueReusableCell(withIdentifier: "Cell",
                                        for: indexPath)
        let result = resultData.value(forKey: "result") as? String ?? ""
        let points = String(resultData.value(forKey: "points") as? Int32 ?? 0)
        let resultText = result + " :  " +  points
        cell.textLabel?.text = resultText
        return cell
     }
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
}
