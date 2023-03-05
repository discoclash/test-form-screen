//
//  PersonDetailesViewCell.swift
//  TestScreen
//
//  Created by G on 09.02.2023.
//

import UIKit

class PersonDetailesCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var detailes: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.clipsToBounds = true
        $0.distribution = .fillEqually
        return $0
    } (UIStackView())
    
    private let detailesLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .systemGray
        $0.font = .systemFont(ofSize: 12)
        $0.alpha = 0
        return $0
    }(UILabel())
    
    lazy var detailTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .black
        $0.addTarget(self, action: #selector(edit), for: .editingChanged)
        return $0
    } (UITextField())
    
    @objc private func edit() {
        guard let text = detailTextField.text else {return}
        if !text.isEmpty {
            UIView.animate(withDuration: 0.5) {
                self.detailesLabel.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.detailesLabel.alpha = 0
            }
        }
    }
    
    private func setupGestures() {
        let tapOnCell = UITapGestureRecognizer(target: self, action: #selector(tapOnCell))
        detailes.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapOnCell)
    }
    
    @objc private func tapOnCell() {
        detailTextField.becomeFirstResponder()
    }
    
    private func layout() {
        contentView.addSubview(detailes)
        detailes.addArrangedSubview(detailesLabel)
        detailes.addArrangedSubview(detailTextField)
        
        NSLayoutConstraint.activate([
            detailes.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            detailes.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            detailes.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            detailes.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func setupDelegate(delegate: UITextFieldDelegate) {
        detailTextField.delegate = delegate
    }
    
    func setupCell(detail: String, number: Bool) {
        detailTextField.placeholder = detail
        detailesLabel.text = detail
        if number {
            detailTextField.keyboardType = .numberPad
        }
    }
}


