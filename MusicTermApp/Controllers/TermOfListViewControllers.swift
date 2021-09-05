//
//  TermOfListViewControllers.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/09/05.
//

import Foundation
import UIKit
import RealmSwift

class TermOfListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let realm = try! Realm()
    
    @IBOutlet weak var termTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        tableViewConfig()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let allData = realm.objects(QuestionHistory.self)
        if allData.count > 90 {
            return 90
        } else {
            return allData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        let allData = realm.objects(QuestionHistory.self).sorted(byKeyPath: "id", ascending: false)
        
        let celldata = allData[indexPath.row]
        cell.termLabel.text = celldata.musicTerm
        cell.meaningLabel.text = celldata.musicTermMeaning
        if celldata.correctOrFalse {
            cell.correctOrFalseImage.image = UIImage(named: "maru")
        } else {
            cell.correctOrFalseImage.image = UIImage(named: "batsu")
        }
        
        return cell
    }
    
    func tableViewConfig() {
        termTableView.rowHeight = view.bounds.height / 10
    }

}
