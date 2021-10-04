//
//  RankingViewController.swift
//  MusicTermApp
//
//  Created by 槙和馬 on 2021/09/08.
//

import Foundation
import Firebase
import UIKit

class RankingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    var users: Array<User>?
    enum SortType {
        case best
        case total
    }
    
    var sortType: SortType = .best
    
    @IBOutlet weak var modalContentsView: UIView!
    @IBOutlet weak var rankingTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
        
    @IBAction func changeSegmentdConrol(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            sortType = .best
            rankingTableView.reloadData()
        case 1:
            sortType = .total
            rankingTableView.reloadData()
        default:
        print("error")
        }
    }

//MARK: -ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
        rankingTableView.delegate = self
        rankingTableView.dataSource = self
        tappedGestureSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rankingTableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableViewHeight.constant = modalContentsView.bounds.height - 40
    }

//MARK: -テーブルビュー
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users == nil {
            return 2
        } else {
            return users!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankingTableViewCell", for: indexPath) as! RankingTableViewCell
        
        fetchUsersData { (users) in
            let user = users[indexPath.row]
            cell.rankingLabel.text = String(indexPath.row + 1)
            cell.nameLabel.text = user.name
            cell.profileImage.image = UIImage(named: user.currentImage)
            if self.sortType == .best {
                cell.scoreLabel.text = String(user.bestScore)
            } else {
                cell.scoreLabel.text = String(user.totalScore)
            }
        }
        return cell
    }
//MARK: -firebase
    private func fetchUsersData(completion: @escaping ([User]) -> Void) {
        Firestore.firestore().collection("users").getDocuments { (snapshots, err) in
            if let err = err {
                print("データの取得に失敗\(err)")
            }
            self.users = snapshots?.documents.map({ (snapshot) -> User in
                let dic = snapshot.data()
                let user = User.init(dic: dic)
                return user
            })
            if self.sortType == .best {
                self.sortedByBestscore()
            } else {
                self.sortedByTotalscore()
            }
            completion(self.users!)
        }
    }
//MARK: -sort
    private func sortedByBestscore() {
        users!.sort (by: {
            $0.bestScore > $1.bestScore
        })
    }
    
    private func sortedByTotalscore() {
        users!.sort (by: {
            $0.totalScore > $1.totalScore
        })
    }
//MARK: -GestureRecognizer
    private func tappedGestureSetup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
    }
    
    @objc func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view!.isDescendant(of: modalContentsView)) {
            return false
        } else {
            return true
        }
    }
}
