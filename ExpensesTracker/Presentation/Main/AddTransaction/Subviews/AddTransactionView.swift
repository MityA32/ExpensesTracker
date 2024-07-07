//
//  AddTransactionView.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 07.07.2024.
//

import UIKit

final class AddTransactionView: UIView {
    
    let backgroundView = UIView()
    let mainLabel = UILabel()
    let amountTextField = UITextField()
    let categoryPicker = UIPickerView()
    let addButton = UIButton(type: .system)
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupBackground()
        setupMainLabel()
        setupAmountTextField()
        setupAddButton()
        setupLayout()
        
        categoryPicker.setValue(UIColor.white, forKeyPath: "textColor")
    }
    
    private func setupLayout() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundView)
        backgroundView.addSubview(mainLabel)
        backgroundView.addSubview(amountTextField)
        backgroundView.addSubview(categoryPicker)
        backgroundView.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 300),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            mainLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 12),
            mainLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 24),
            mainLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -24),
            mainLabel.heightAnchor.constraint(equalToConstant: 24),
            
            amountTextField.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 12),
            amountTextField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 24),
            amountTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -24),

            categoryPicker.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            categoryPicker.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20),
            categoryPicker.widthAnchor.constraint(equalToConstant: 200),
            categoryPicker.heightAnchor.constraint(equalToConstant: 100),

            addButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            addButton.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 20),
            addButton.heightAnchor.constraint(equalToConstant: 32),
            addButton.widthAnchor.constraint(equalToConstant: 64)
        ])
        
    }
    
    private func setupBackground() {
        backgroundView.backgroundColor = .hex41424C
        backgroundView.layer.cornerRadius = 16
        backgroundView.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        backgroundView.layer.borderWidth = 1
    }
    
    private func setupMainLabel() {
        mainLabel.text = "Transaction Details"
        mainLabel.font = .sfProDisplay(ofSize: 18, weight: .bold)
        mainLabel.textAlignment = .center
        mainLabel.textColor = .white
    }
    
    private func setupAmountTextField() {
        amountTextField.attributedPlaceholder = NSAttributedString(string: "Enter amount", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        amountTextField.keyboardType = .decimalPad
        amountTextField.borderStyle = .roundedRect
        amountTextField.backgroundColor = .hexE0E0E0
        amountTextField.textColor = .black
    }
    
    private func setupAddButton() {
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.font = .sfProDisplay(ofSize: 16, weight: .medium)
        addButton.backgroundColor = .systemBlue
        addButton.layer.cornerRadius = 16
    }

}
