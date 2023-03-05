//
//  DoneViewController.swift
//  TestScreen
//
//  Created by G on 11.02.2023.
//

import UIKit

final class DoneViewController: UIViewController {
    
    private lazy var profileImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 50
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private lazy var detailsLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 20)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    init(image: UIImage?, message: String) {
        super.init(nibName: nil, bundle: nil)
        if let image = image {
            self.profileImage.image = image
        }
        self.detailsLabel.text = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        view.backgroundColor = .white
    }
    
    private func layout() {
        view.addSubview(profileImage)
        view.addSubview(detailsLabel)

        NSLayoutConstraint.activate([
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 100),
            profileImage.widthAnchor.constraint(equalToConstant: 100),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
                        
            detailsLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 30),
            detailsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailsLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -30),
            detailsLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 30),
            detailsLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -30)
        ])
    }
    
}
