//
//  ResultViewController.swift
//  CompoundInterest
//
//  Created by Эрмек Жоробеков on 24.01.2022.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var allDeposits: UILabel!
    @IBOutlet weak var percentProfit: UILabel!
    
    var resultModel: Results!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultLabel.text = String(resultModel.total)
        allDeposits.text = String(resultModel.totalDeposits)
        percentProfit.text = String(resultModel.profit)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationVC = segue.destination as? UINavigationController else { return }
        guard let moreResultVC = navigationVC.topViewController as? MoreResultTableViewController else {return}
        moreResultVC.resultModel = resultModel
    }
}
