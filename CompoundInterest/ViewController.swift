//
//  ViewController.swift
//  CompoundInterest
//
//  Created by Ульяна Гритчина on 21.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var firstDepositTF: UITextField!
    @IBOutlet weak var frequencyDepositTF: UITextField!
    @IBOutlet weak var depostiTimeTF: UITextField!

    @IBOutlet weak var percentTF: UITextField!
    
    @IBOutlet weak var frequencyDepositLabel: UILabel!
    
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var settingsStackView: UIStackView!
    @IBOutlet weak var calculateButton: UIButton!
    

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet var textFieldCollection: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsStackView.layer.cornerRadius = 14
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        segmentControl.isHidden = false
        userInterfaceIsOn()
    }

    
    @IBAction func settingsTapped(_ sender: Any) {
        userInterfaceIsOn()
}
    
    
    @IBAction func segmentControlValueChanged(_ sender: Any) {
        segmentControl.selectedSegmentIndex == 0 ? (frequencyDepositLabel.text = "Ежемесячный депозит") : (frequencyDepositLabel.text = "Ежегодный депозит")
    }
    
    private func userInterfaceIsOn() {
    
        let userInterfaceIsOn = segmentControl.isHidden ? false : true
  
        for textField in textFieldCollection {
            textField.isUserInteractionEnabled = userInterfaceIsOn
        }
        mainStackView.alpha = userInterfaceIsOn == true ? 1 : 0.3
        settingsStackView.isHidden = userInterfaceIsOn
        segmentControl.isHidden = userInterfaceIsOn
        calculateButton.isEnabled = userInterfaceIsOn
    }
    
}
