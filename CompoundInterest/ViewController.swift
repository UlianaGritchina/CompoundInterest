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
    @IBOutlet weak var depositTimeTF: UITextField!
    @IBOutlet weak var percentTF: UITextField!
    
    @IBOutlet weak var frequencyDepositLabel: UILabel!
    
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var settingsStackView: UIStackView!
    @IBOutlet weak var calculateButton: UIButton!
    

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet var textFieldCollection: [UITextField]!
    
    private var currentTextField = UITextField()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculateButton.isEnabled = false
        settingsStackView.layer.cornerRadius = 14
        percentTF.rightView = UIView()
    }


    
    @IBAction func settingsTapped(_ sender: Any) {
        userInterfaceIsOn()
}
    
    
    @IBAction func segmentControlValueChanged(_ sender: Any) {
        segmentControl.selectedSegmentIndex == 0 ? (frequencyDepositLabel.text = "Ежемесячный депозит") : (frequencyDepositLabel.text = "Ежегодный депозит")
    }
    

    @IBAction func calculateButtonIsTapped() {
        checkPercentTF()
        calculateButtonIsOn()
    }
    
   
    
}

// MARK: - Private Methods
extension ViewController {
    
    private func calculateButtonIsOn() {
        
        var textfieldsIsEmpty = true
        
        for textField in textFieldCollection {
            if textField.hasText {
            textfieldsIsEmpty = false
            } else {
            textfieldsIsEmpty = true
            }
        }
        
        calculateButton.isEnabled = textfieldsIsEmpty ? false : true
        
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
    
    @objc private func didTapDone() {
        calculateButtonIsOn()
        view.endEditing(true)
    }
    
    
    private func checkPercentTF() {
        
        let percentTextFieldNumber = Int(percentTF.text ?? "0") ?? 0
        
        if percentTextFieldNumber < 0 || percentTextFieldNumber > 100 {
            percentTF.text = ""
         showAlert(title: "Неверный формат", message: "Введите число от 0 до 100")
        }
    }
    
    
    
    
    private func showAlert(title: String, message: String, textField: UITextField? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            textField?.text = ""
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}




extension ViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        segmentControl.isHidden = false
        userInterfaceIsOn()
        calculateButtonIsOn()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentTextField = textField
        return true
    }
    
    @objc private func nextTF() {
        
        switch currentTextField {
        case firstDepositTF:
            frequencyDepositTF.becomeFirstResponder()
        case frequencyDepositTF:
            depositTimeTF.becomeFirstResponder()
        case depositTimeTF:
            percentTF.becomeFirstResponder()
        default:
            firstDepositTF.becomeFirstResponder()
        }
    }
    
    @objc private func previousTF() {
        
        switch currentTextField {
        case firstDepositTF:
            percentTF.becomeFirstResponder()
        case frequencyDepositTF:
            firstDepositTF.becomeFirstResponder()
        case depositTimeTF:
            frequencyDepositTF.becomeFirstResponder()
        default:
            firstDepositTF.becomeFirstResponder()
        }
    }
    
     func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        textField.inputAccessoryView = keyboardToolbar
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTapDone)
        )
         
        let nextButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.down"),
            style: .done,
            target: self,
            action: #selector(nextTF)
        )
        
         let previousButton = UIBarButtonItem(
             image: UIImage(systemName: "arrow.up"),
             style: .done,
             target: self,
             action: #selector(previousTF)
         )
         
         
        let flexBarButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        keyboardToolbar.items = [previousButton, nextButton, flexBarButton, doneButton]
    }
    
}
