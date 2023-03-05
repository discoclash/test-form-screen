//
//  AvatarViewCell.swift
//  TestScreen
//
//  Created by G on 09.02.2023.
//

import UIKit

protocol UploadImageDelegate: AnyObject {
    func uploadImage(image: UIImageView)
}

class AvatarViewCell: UITableViewCell {
    
    weak var delegate: UploadImageDelegate?
    
    private lazy var profileImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "add")
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 50
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        setupGestures()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGestures() {
        let tapOnImage = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapOnImage)
    }
    
    @objc private func tapImage() {
        delegate?.uploadImage(image: profileImage)
    }
    
    private func layout() {
        contentView.addSubview(profileImage)

        NSLayoutConstraint.activate([
            profileImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 100),
            profileImage.widthAnchor.constraint(equalToConstant: 100),
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            profileImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
}
