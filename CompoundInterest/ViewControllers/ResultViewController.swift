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
        
        resultLabel.text = String(resultModel.mainResalt)
        allDeposits.text = String(resultModel.sum)
        percentProfit.text = String(resultModel.proc)
    }
}
