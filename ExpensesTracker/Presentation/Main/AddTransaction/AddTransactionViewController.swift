//
//  AddTransactionViewController.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 06.07.2024.
//

import UIKit

final class AddTransactionViewController: UIViewController {
    
    let addTransactionView = AddTransactionView()
    let dismissButton = UIButton()
    
    weak var delegate: AddTransactionDelegate?
    
    let viewModel: AddTransactionViewModel
    
    init(viewModel: AddTransactionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setup() {
        setupVC()
        setupButtons()
        setupDelegates()
        setupLayout()
    }
    
    private func setupVC() {
        view.backgroundColor = .black.withAlphaComponent(0.85)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func setupButtons() {
        addTransactionView.addButton.addTarget(self, action: #selector(addTransaction), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissScreen), for: .touchUpInside)
        dismissButton.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
        dismissButton.imageView?.contentMode = .scaleAspectFill
    }
    
    private func setupDelegates() {
        addTransactionView.categoryPicker.delegate = self
        addTransactionView.categoryPicker.dataSource = self
    }
    
    private func setupLayout() {
        addTransactionView.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(addTransactionView)
        view.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
        
            addTransactionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTransactionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            addTransactionView.heightAnchor.constraint(equalToConstant: 300),
            addTransactionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            addTransactionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            dismissButton.bottomAnchor.constraint(equalTo: addTransactionView.topAnchor, constant: -12),
            dismissButton.widthAnchor.constraint(equalToConstant: 32),
            dismissButton.heightAnchor.constraint(equalTo: dismissButton.widthAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: addTransactionView.trailingAnchor, constant: -24),
        
        ])
    }
    
    @objc func addTransaction() {
        guard let amountText = addTransactionView.amountTextField.text else { return }
        
        let selectedCategory = viewModel.categories[addTransactionView.categoryPicker.selectedRow(inComponent: 0)]
        
        
        viewModel
            .checkTransactionPossibility(transactionValue: amountText) { canMakeTransaction in
            if canMakeTransaction {
                delegate?.didAddTransaction(value: amountText, category: selectedCategory)
            } else {
                showInsufficientFundsAlert()
            }
        }
        
        
    }
    
    private func showInsufficientFundsAlert() {
        let alertController = UIAlertController(title: "Error", message: "Insufficient Funds", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func dismissScreen() {
        delegate?.dismiss()
    }
    
}

extension AddTransactionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - UIPickerViewDelegate & UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel.categories[row].rawValue.capitalized
    }
}
