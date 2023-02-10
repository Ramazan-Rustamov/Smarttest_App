//
//  ShapeTableViewCell.swift
//  Smarttest_App
//
//  Created by Ramazan Rustamov on 09.02.23.
//

import UIKit

class ShapeTableViewCell: UITableViewCell {
    
    private lazy var plusButton: UIButton = {
       let button = UIButton()
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 40)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .green
        button.isHidden = true
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "TimesNewRomanPSMT", size: 20)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        
        return label
    }()
    
    var title: String {
        get { titleLabel.text ?? "" }
        set { titleLabel.text = newValue }
    }
    
    var action: (() -> Void)?
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cellID")
        
        backgroundColor = .white
        
        addSubview(plusButton)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            plusButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            plusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            plusButton.heightAnchor.constraint(equalToConstant: 50),
            plusButton.widthAnchor.constraint(equalToConstant: 50),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    @objc private func plusButtonTapped() {
        action?()
    }
    
    func showPlusButton() {
        plusButton.isHidden = false
    }
    
    func hidePlusButton() {
        plusButton.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
