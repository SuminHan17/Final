//
//  TestWrongViewController.swift
//  Final
//
//  Created by 한수민 on 20/06/2019.
//  Copyright © 2019 한수민. All rights reserved.
//

import UIKit

class TestWrongViewController: UIViewController {

    var index = 0
    var originalNumbers = Array (0...fetchedArray.count-1)
    var indexnum:[Int] = []
    @IBOutlet var firstLabel: UILabel!
    @IBOutlet var secondLabel: UILabel!
    @IBOutlet var thirdLabel: UILabel!
    
    @IBOutlet var firstMean: UITextField!
    @IBOutlet var secondMean: UITextField!
    @IBOutlet var thirdMean: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalNumbers = Array (0...fetchedArray.count-1)
        indexnum = []
        
        for _ in 0...2 {
            index = Int(arc4random_uniform(UInt32(originalNumbers.count)))
            indexnum.append(originalNumbers[index])
            originalNumbers.remove(at: index)
        }
        var getEnglish = fetchedArray[indexnum[0]]
        firstLabel.text = getEnglish.english

        getEnglish = fetchedArray[indexnum[1]]
        secondLabel.text = getEnglish.english

        getEnglish = fetchedArray[indexnum[2]]
        thirdLabel.text = getEnglish.english
    }
    
    @IBAction func bakcButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? ResultWrongViewController {

            var getEnglish = fetchedArray[indexnum[0]]
            if firstMean.text == getEnglish.mean as String {
                destination.result.append(getEnglish.english)
            }
            getEnglish = fetchedArray[indexnum[1]]
            if secondMean.text == getEnglish.mean as String {
                destination.result.append(getEnglish.english)
            }
            getEnglish = fetchedArray[indexnum[2]]
            if thirdMean.text == getEnglish.mean as String {
                destination.result.append(getEnglish.english)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
