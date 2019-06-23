//
//  TestTableViewController.swift
//  Final
//
//  Created by 한수민 on 12/06/2019.
//  Copyright © 2019 한수민. All rights reserved.
//

import UIKit

var fetchedArray: [Englishes] = Array()
class TestTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchedArray = []
    }
    override func viewDidAppear(_ animated: Bool) {
        self.downloadDataFromServer()
    }

    // MARK: - Table view data source
    func downloadDataFromServer() -> Void {
        fetchedArray = []
        let urlString: String = "http://condi.swu.ac.kr/student/T16/English/bringEnglish.php"
        guard let requestURL = URL(string: urlString) else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "id=" + usernames
        request.httpBody = restString.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in guard responseError == nil else { print("Error: calling POST"); return; }
            guard let receivedData = responseData else {
                print("Error: not receiving Data"); return; }
            let response = response as! HTTPURLResponse
            if !(200...299 ~= response.statusCode) { print("HTTP response Error!"); return }
            do {
                if let jsonData = try JSONSerialization.jsonObject (with: receivedData, options:.allowFragments) as? [[String: Any]] {
                    for i in 0...jsonData.count-1 {
                        let newData: Englishes = Englishes()
                        var jsonElement = jsonData[i]
                        newData.english = jsonElement["english"] as! String
                        newData.mean = jsonElement["mean"] as! String
                        fetchedArray.append(newData)
                    }
                    DispatchQueue.main.async { self.tableView.reloadData() } }
            } catch { print("Error: Catch") } }
        task.resume()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Plus Cell", for: indexPath)

        let item = fetchedArray[indexPath.row]
        cell.textLabel?.text = item.english
        cell.detailTextLabel?.text = item.mean
        // Configure the cell...

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
            let urlString: String = "http://condi.swu.ac.kr/student/T16/English/delectEnglish.php"
            let a = fetchedArray[indexPath.row].english
            guard let requestURL = URL(string: urlString) else { return }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            let restString: String = "userid=" + usernames + "&english=" + a
            request.httpBody = restString.data(using: .utf8)

            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else { return }
                guard let receivedData = responseData else { return }
                if let utf8Data = String(data: receivedData, encoding: .utf8) { print(utf8Data) }
            }
            fetchedArray.remove(at: indexPath.row)
            task.resume()
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    @IBAction func alertBt(_ sender: Any) {
        if fetchedArray.count < 3 {
            let alert = UIAlertController(title: "틀린 단어가 3개 이상일 때부터 이용할 수 있습니다",
                                          message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
            return
        }
        else {
            self.performSegue(withIdentifier: "toQuiz", sender: self)
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
