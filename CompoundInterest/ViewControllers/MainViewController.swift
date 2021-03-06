//
//  ViewController.swift
//  CompoundInterest
//
//  Created by Ульяна Гритчина on 21.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var firstDepositTextField: UITextField!
    @IBOutlet weak var frequencyDepositTextField: UITextField!
    @IBOutlet weak var depositTimeTextField: UITextField!
    @IBOutlet weak var percentTextField: UITextField!
    
    @IBOutlet weak var frequencyDepositLabel: UILabel!
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var settingsStackView: UIStackView!
    @IBOutlet weak var calculateButton: UIButton!
    

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet var textFieldCollection: [UITextField]!
    
    private var currentTextField = UITextField()
    private var isUserInterfaceOn = true
    
    private var resultModel = Results(results: [], totalDeposits: 0, depositTime: [])

    private var timeType = TimeTypes.months
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInterfaceIsOn()
        calculateButtonIsOn()
        settingsStackView.layer.cornerRadius = 14
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationVC = segue.destination as? UINavigationController else { return }
        guard let resultVC = navigationVC.topViewController as? ResultViewController else {return}
        resultVC.resultModel = resultModel
    }
    
    @IBAction func unwindSegueToMainScreen(segue: UIStoryboardSegue) {}
    
    
    @IBAction func settingsTapped(_ sender: Bool) {
        
        switch isUserInterfaceOn {
        case true:
            showSettings()
            isUserInterfaceOn = false
        case false:
            userInterfaceIsOn()
            isUserInterfaceOn = true
        }
}
    
    
    @IBAction func segmentControlValueChanged(_ sender: Any) {
        segmentControl.selectedSegmentIndex == 0 ? (frequencyDepositLabel.text = "Ежемесячный депозит") : (frequencyDepositLabel.text = "Ежегодный депозит")
        segmentControl.selectedSegmentIndex == 0 ? (timeType = .months) : (timeType = .years)
    }
    

    @IBAction func calculateButtonIsTapped() {
        getResult()
        checkPercentTF()
    }
}

// MARK: - Private Methods
extension ViewController {
    
    private func calculateButtonIsOn() {
        
        var emptyTexFieldCount = textFieldCollection.count
        
        for textField in textFieldCollection {
            if textField.hasText {
            emptyTexFieldCount -= 1
            }
        }
        
        calculateButton.isEnabled = emptyTexFieldCount == 0 ? true : false
        
    }
    
    private func userInterfaceIsOn() {
        mainStackView.alpha = 1
        settingsStackView.isHidden = true
        for textField in textFieldCollection {
            textField.isUserInteractionEnabled = true
        }
    }
    
    private func showSettings() {
        mainStackView.alpha = 0.3
        settingsStackView.isHidden = false
        for textField in textFieldCollection {
            textField.isUserInteractionEnabled = false
        }
    }

    
    @objc private func didTapDone() {
        calculateButtonIsOn()
        view.endEditing(true)
    }
    
    
    private func checkPercentTF() {
        
        let percentTextFieldNumber = Int(percentTextField.text ?? "0") ?? 0
        
        if percentTextFieldNumber <= 0 || percentTextFieldNumber > 100 {
            percentTextField.text = ""
         showAlert(title: "Указан неверный процент", message: "Введите число от 1 до 100")
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
    
    
    private func getResult () {
        
        switch timeType {
        case .months:
            getResults(withPeriod: 12)
        case .years:
            getResults(withPeriod: 1)
        }

        func getResults(withPeriod: Float) {
            
            guard var firstDeposit = Float(firstDepositTextField.text ?? "0") else { return }
            guard let frequencyDeposit = Float(frequencyDepositTextField.text ?? "0") else { return }
            guard let depositTime = Int(depositTimeTextField.text ?? "0") else { return }
            guard let percent = Float(percentTextField.text ?? "0") else { return }
            
            resultModel.totalDeposits = Int(firstDeposit + frequencyDeposit * Float(depositTime) * withPeriod)
            
            for i in 1...depositTime {
                let result = firstDeposit * pow(1 + percent / 100, 1) + frequencyDeposit * withPeriod
                firstDeposit = result
                resultModel.results.append(Int(round(firstDeposit * 1)) / 1)
                resultModel.depositTime.append(i)
            }
        }
    }
}





extension ViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        isUserInterfaceOn = true
        userInterfaceIsOn()
        calculateButtonIsOn()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentTextField = textField
        return true
    }
    
    @objc private func nextTF() {
        
        switch currentTextField {
        case firstDepositTextField:
            frequencyDepositTextField.becomeFirstResponder()
        case frequencyDepositTextField:
            depositTimeTextField.becomeFirstResponder()
        case depositTimeTextField:
            percentTextField.becomeFirstResponder()
        default:
            firstDepositTextField.becomeFirstResponder()
        }
    }
    
    @objc private func previousTF() {
        
        switch currentTextField {
        case firstDepositTextField:
            percentTextField.becomeFirstResponder()
        case frequencyDepositTextField:
            firstDepositTextField.becomeFirstResponder()
        case depositTimeTextField:
            frequencyDepositTextField.becomeFirstResponder()
        default:
            firstDepositTextField.becomeFirstResponder()
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
