//
//  FirstViewController.swift
//  Final
//
//  Created by 한수민 on 11/06/2019.
//  Copyright © 2019 한수민. All rights reserved.
//

import UIKit
import CoreData

var usernames:String = ""

class FirstViewController: UIViewController {
    

    @IBOutlet var storage: UILabel!
    @IBOutlet var userName: UILabel!

    
    @IBOutlet var labelStatus: UILabel!
    @IBOutlet var english: UITextField!
    @IBOutlet var mean: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        englishesNew = []
        userName.text = usernames
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        englishesNew = []
        labelStatus.text = ""
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "English")
        
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
        storage.text = String(englishesNew.count)
        englishes = []
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { textField.resignFirstResponder()
        return true
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
    @IBAction func plus(_ sender: Any) {
        if english.text == "" {
            labelStatus.text = "영어 단어를 입력하세요";
            return;
        }
        if mean.text == "" {
            labelStatus.text = "단어 뜻을 입력하세요";
            return;
        }
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "English", in: context)

        // friend record를 새로 생성함
        let object = NSManagedObject(entity: entity!, insertInto: context)
        object.setValue(usernames, forKey: "name")
        object.setValue(english.text, forKey: "english")
        object.setValue(mean.text, forKey: "mean")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.englishList.append(usernames)

        
        do {
            try context.save()
            print("saved!")
            labelStatus.text = "삽입 완료!"
            storage.text = String(englishesNew.count + 1)
            english.text = ""
            mean.text = ""
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
}
    
    @IBAction func buttonLogout(_ sender: Any) {
        let alert = UIAlertController(title:"로그아웃 하시겠습니까?",message: "",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in let urlString: String = "http://condi.swu.ac.kr/student/T16/login/logout.php"
            guard let requestURL = URL(string: urlString) else { return }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else { return } }
            task.resume()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginView = storyboard.instantiateViewController(withIdentifier: "LoginView")
        self.present(loginView, animated: true, completion: nil)
            }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
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
