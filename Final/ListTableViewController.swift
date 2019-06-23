//
//  ListTableViewController.swift
//  Final
//
//  Created by 한수민 on 11/06/2019.
//  Copyright © 2019 한수민. All rights reserved.
//

import UIKit
import CoreData

var englishes: [NSManagedObject] = []
var englishesNew: [NSManagedObject] = []

class ListTableViewController: UITableViewController {
    
    let appDelegate = AppDelegate()
    @IBOutlet var secondTab: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    // View가 보여질 때 자료를 DB에서 가져오도록 한다
    
    
    override func viewDidAppear(_ animated: Bool) {
        englishes = []
        englishesNew = []
        super.viewDidAppear(animated)
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "English")
        let sortDescriptor = NSSortDescriptor (key: "english", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            englishes = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        for i in 0 ..< englishes.count {
            if (usernames == englishes[i].value(forKey: "name") as? String) {
                englishesNew.append(englishes[i])
            }
        }
        self.tableView.reloadData()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return englishesNew.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "English Cell", for: indexPath)
        let getEnglish = englishesNew[indexPath.row]
        
        var display: String = ""
        if let nameLabel = getEnglish.value(forKey: "english") as? String {
            display = nameLabel }
        
        cell.textLabel?.text = display
        cell.detailTextLabel?.text = getEnglish.value(forKey: "mean") as? String
        return cell
    }



    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }



    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = getContext()
            context.delete(englishesNew[indexPath.row])
            do {
                try context.save()
                print("deleted!")
            } catch let error as NSError {
                print("Could not delete \(error), \(error.userInfo)") }
            // 배열에서 해당 자료 삭제
            englishesNew.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }



    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
