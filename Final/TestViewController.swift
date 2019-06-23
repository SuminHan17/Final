//
//  TestViewController.swift
//  Final
//
//  Created by 한수민 on 12/06/2019.
//  Copyright © 2019 한수민. All rights reserved.
//

import UIKit
import CoreData

class TestViewController: UIViewController {


    var index = 0
    var originalNumbers = Array (0...englishes.count-1)
    var indexnum:[Int] = []
    
    @IBOutlet var english01: UILabel!
    @IBOutlet var english02: UILabel!
    @IBOutlet var english03: UILabel!
    @IBOutlet var english04: UILabel!
    @IBOutlet var english05: UILabel!
    
    @IBOutlet var answer01: UITextField!
    @IBOutlet var answer02: UITextField!
    @IBOutlet var answer03: UITextField!
    @IBOutlet var answer04: UITextField!
    @IBOutlet var answer05: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexnum = []
        for _ in 0...4 {
            index = Int(arc4random_uniform(UInt32(originalNumbers.count)))
            indexnum.append(originalNumbers[index])
            originalNumbers.remove(at: index)
        }
        var getEnglish = englishes[indexnum[0]]
        english01.text = getEnglish.value(forKey: "english") as? String
        
        getEnglish = englishes[indexnum[1]]
        english02.text = getEnglish.value(forKey: "english") as? String
        
        getEnglish = englishes[indexnum[2]]
        english03.text = getEnglish.value(forKey: "english") as? String
        
        getEnglish = englishes[indexnum[3]]
        english04.text = getEnglish.value(forKey: "english") as? String
        
        getEnglish = englishes[indexnum[4]]
        english05.text = getEnglish.value(forKey: "english") as? String
        
    }
    

    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    
    @IBAction func buttonBack() {
        self.dismiss(animated: true, completion: nil)
    }

    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
       
        if let destination = segue.destination as? ResultViewController {
            var getEnglish = englishes[indexnum[0]]
            if answer01.text != getEnglish.value(forKey: "mean") as? String {
                destination.result.append(indexnum[0])
            }
            getEnglish = englishes[indexnum[1]]
            if answer02.text != getEnglish.value(forKey: "mean") as? String {
                destination.result.append(indexnum[1])
            }
            getEnglish = englishes[indexnum[2]]
            if answer03.text != getEnglish.value(forKey: "mean") as? String {
                destination.result.append(indexnum[2])
            }
            getEnglish = englishes[indexnum[3]]
            if answer04.text != getEnglish.value(forKey: "mean") as? String {
                destination.result.append(indexnum[3])
            }
            getEnglish = englishes[indexnum[4]]
            if answer05.text != getEnglish.value(forKey: "mean") as? String {
                destination.result.append(indexnum[4])
            }
        }
    }
}
