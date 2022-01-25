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
        
        print(resultModel.results)
        
        resultLabel.text = String(format: "%.2f", resultModel.mainResult)
        allDeposits.text = String(format: "%.2f", resultModel.sum)
        percentProfit.text = String(format: "%.2f", resultModel.proc)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationVC = segue.destination as? UINavigationController else { return }
        guard let moreResultVC = navigationVC.topViewController as? MoreResultTableViewController else {return}
        moreResultVC.resultModel = resultModel
    }
}
