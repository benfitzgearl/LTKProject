//
//  MainTableViewController.swift
//  LTKProject
//
//  Created by Ben Fitzgearl  on 5/5/22.
//

import UIKit

class MainTableViewController: UITableViewController {

    let cellId = "LTKCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "LTKTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if LTKDataManager.shared().ltks.count == 0 {
            loadMoreData()
        }
    }
    
    //TODO: Add support for limit and offset fetch, appending to existing table, etc.
    func loadMoreData() {
        LTKDataManager.shared().loadData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LTKDataManager.shared().ltks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? LTKTableViewCell else {
            return UITableViewCell()
        }
        cell.associatedLTK = LTKDataManager.shared().ltks[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ltkDetailViewController = LTKDetailViewController(associatedLTK: LTKDataManager.shared().ltks[indexPath.row])
        self.navigationController?.pushViewController(ltkDetailViewController, animated: true)
    }
}
