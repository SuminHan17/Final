//
//  ResultViewController.swift
//  Final
//
//  Created by 한수민 on 12/06/2019.
//  Copyright © 2019 한수민. All rights reserved.
//

import UIKit
import CoreData

class ResultViewController: UIViewController {

    @IBOutlet var correct: UILabel!
    @IBOutlet var wrong: UILabel!
    @IBOutlet var labelStatus: UILabel!
    @IBOutlet var stobt: UIButton!
    
    var result:[Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        stobt.isHidden = true
        labelStatus.isHidden = true
        wrong.text = String(result.count)
        correct.text = String(5-result.count)
        if result.count > 0 {
            stobt.isHidden = false
        }
    }
    func executeRequest (request: URLRequest) -> Void {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                print("Error: calling POST")
                return
            }
            
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return
            }
            
            if let utf8Data = String(data: receivedData, encoding: .utf8) {
                DispatchQueue.main.async {     // for Main Thread Checker
                    self.labelStatus.text = utf8Data
                    print(utf8Data)  // php에서 출력한 echo data가 debug 창에 표시됨
                }
            }
        }
        task.resume()
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    @IBAction func insertEnglish(_ sender: Any) {
        labelStatus.isHidden = false
        let urlString: String = "http://condi.swu.ac.kr/student/T16/English/insertEnglish.php"
        guard let requestURL = URL(string: urlString)
            else {
                return
        }
        for i in 0...result.count-1 {
            let getEnglish = englishes[result[i]]
            let first:String = (getEnglish.value(forKey: "english") as? String)!
            let firstmean:String = (getEnglish.value(forKey: "mean") as? String)!
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            let restString: String = "id=" + usernames + "&english=" + String(first) + "&mean=" + String(firstmean)
            print(restString)
            request.httpBody = restString.data(using: .utf8)
            self.executeRequest(request: request)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.list.append(first)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainView = storyboard.instantiateViewController(withIdentifier: "Main")
        self.present(mainView, animated: true, completion: nil)
    }
    
}
