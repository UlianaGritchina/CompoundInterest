//
//  MoreResultTableViewController.swift
//  CompoundInterest
//
//  Created by Эрмек Жоробеков on 24.01.2022.
//

import UIKit

class MoreResultTableViewController: UITableViewController {

    var resultModel: Results!
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        resultModel.depositTime.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Год \(resultModel.depositTime[section])"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let result = resultModel.results[indexPath.section]
        
        content.text = String(result)
        cell.contentConfiguration = content
        
        return cell
    }
}
