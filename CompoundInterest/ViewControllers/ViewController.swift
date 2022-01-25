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
    private var isUserInterfaceOn = true
    
    
    
    private var resultModel = Results(period: 0, start: 0, mainResult: 0, results: [0], sum: 0)
    private var firstDeposit: Float!
    private var frequencyDeposit: Float!
    private var depositTime: Int!
    private var percent: Float!
    private var sum: Float!
    private var result: Float!
    private var results: [Float] = []
    private var timeType: timeTypes = .months

    
    enum timeTypes {
        case months
        case years
    }
    
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
        timeType = .years
    }
    

    @IBAction func calculateButtonIsTapped() {
        getResults()
        print(resultModel)
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
        
        let percentTextFieldNumber = Int(percentTF.text ?? "0") ?? 0
        
        if percentTextFieldNumber <= 0 || percentTextFieldNumber > 100 {
            percentTF.text = ""
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
    
    private func getResults() {
        sum = 0
        result = 0
        firstDeposit = Float(firstDepositTF.text ?? "0")
        frequencyDeposit = Float(frequencyDepositTF.text ?? "0")
        depositTime = Int(depositTimeTF.text ?? "0")
        percent = Float(percentTF.text ?? "0")
        results = []
        result = firstDeposit
        
        if timeType == .months {
            
            percent = percent / 12
            result = result + (result * percent / 100)
            results.append(result)
            
            for _ in 1..<depositTime {
                sum += frequencyDeposit
                result = result + frequencyDeposit + (((result + frequencyDeposit) * percent / 100))
                results.append(result)
            }
            
        } else {
            for _ in 0..<depositTime {
                result += frequencyDeposit
                percent = result * percent / 100
                result += percent
                results.append(result)
            }
        }
        resultModel = Results(period: depositTime, start: firstDeposit, mainResult: results.last ?? 0, results: results, sum: sum)
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
