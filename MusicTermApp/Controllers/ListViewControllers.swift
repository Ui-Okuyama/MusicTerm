//
//  ListViewControllers.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/09/05.
//

import Foundation
import UIKit
import RealmSwift

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let realm = try! Realm()
    var referenceData: Results<AnswerLog>?
    
    @IBOutlet weak var termTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            setallData()
        case 1:
            setSelectedData()
        default:
            print("error")
        }
    }
//MARK: -ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "出題音楽用語一覧"
        navigationController?.navigationBar.tintColor = .black
        referenceData = realm.objects(AnswerLog.self).sorted(byKeyPath: "id", ascending: false)
        termTableView.dataSource = self
        termTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        termTableView.reloadData()
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let padding_top = view.safeAreaInsets.top
        let padding_bottom = view.safeAreaInsets.bottom
        tableViewHeight.constant = CGFloat(view.bounds.height - 40 - padding_top - padding_bottom)
    }
//MARK: -Realmデータ取得
    private func setallData() {
        print("switch")
        referenceData = realm.objects(AnswerLog.self).sorted(byKeyPath: "id", ascending: false)
        self.termTableView.reloadData()
    }
    
    private func setSelectedData() {
        print("switch")
        referenceData = realm.objects(AnswerLog.self).sorted(byKeyPath: "id", ascending: false).filter("correctOrFalse == false")
        self.termTableView.reloadData()
    }

//MARK: -テーブルビュー
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        referenceData!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        let celldata = referenceData![indexPath.row]
        cell.termLabel.text = celldata.musicTerm
        cell.meaningLabel.text = celldata.musicTermMeaning
        if celldata.correctOrFalse {
            cell.correctOrFalseImage.image = UIImage(named: "maru")
        } else {
            cell.correctOrFalseImage.image = UIImage(named: "batsu")
        }
        return cell
    }
}
