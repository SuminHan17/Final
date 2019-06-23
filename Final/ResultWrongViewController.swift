//
//  ResultWrongViewController.swift
//  Final
//
//  Created by 한수민 on 20/06/2019.
//  Copyright © 2019 한수민. All rights reserved.
//

import UIKit

class ResultWrongViewController: UIViewController {
    
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var correctNum: UILabel!
    @IBOutlet var wrongNum: UILabel!
    @IBOutlet var delextBt: UIButton!
    
    var result:[String] = []
    var counts = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delextBt.isHidden = true
        statusLabel.isHidden = true
        correctNum.text = String(result.count)
        wrongNum.text = String(3-result.count)
        if result.count > 0 {
            delextBt.isHidden = false
        }
    }
    
    @IBAction func finishBt(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainView = storyboard.instantiateViewController(withIdentifier: "Main")
        self.present(mainView, animated: true, completion: nil)
    }
    
    @IBAction func delectEnglish(_ sender: Any) {
        let urlString: String = "http://condi.swu.ac.kr/student/T16/English/delectEnglish.php"
        
        for i in 0...result.count-1 {
            Sub: for j in 0...fetchedArray.count-1 {
                if counts == result.count {break}
                if fetchedArray[j].english == result[i] {
                    counts = counts + 1
                    let getEnglish = fetchedArray[j]
                    let a = getEnglish.english
                    guard let requestURL = URL(string: urlString) else { return }
                    var request = URLRequest(url: requestURL)
                    request.httpMethod = "POST"
                    let restString: String = "userid=" + usernames + "&english=" + a
                    request.httpBody = restString.data(using: .utf8)
                    
                    let session = URLSession.shared
                    let task = session.dataTask(with: request) { (responseData, response, responseError) in
                        guard responseError == nil else { return }
                        guard let receivedData = responseData else { return }
                        if let utf8Data = String(data: receivedData, encoding: .utf8) { print(utf8Data)
                        }
                    }
                    fetchedArray.remove(at: j)
                    statusLabel.isHidden = false
                    statusLabel.text = "맞은 단어가 삭제되었습니다"
                    task.resume()
                    break Sub
                }
            }
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

