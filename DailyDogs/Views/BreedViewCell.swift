//
//  BreedViewCell.swift
//  DailyDogs
//
//  Created by Ramona Cvelf on 31.03.21.
//

import Foundation
import UIKit
import SDWebImage

class BreedViewCell: UICollectionViewCell {
    var breed: Breed?
    
    private let horizontalStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isLayoutMarginsRelativeArrangement = true
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 6, leading: 2, bottom: 6, trailing: 2)
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 8
        
        return $0
    }(UIStackView())
    
    private let breedImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 30
        

        return $0
    }(UIImageView())
    
    private let breedNameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .boldSystemFont(ofSize: 20)
        
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(breedImageView)
        horizontalStackView.addArrangedSubview(breedNameLabel)
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo:  contentView.layoutMarginsGuide.trailingAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            breedImageView.heightAnchor.constraint(equalToConstant: 60),
            breedImageView.widthAnchor.constraint(equalTo: breedImageView.heightAnchor)
        ])
    }
    
    func configure(_ breed: Breed) {
        self.breed = breed
        breedImageView.sd_setImage(with: URL(string: self.breed?.images?[0] ?? ""), placeholderImage: UIImage(named: "BreedImagePlaceholder"))
        
        breedNameLabel.text = self.breed?.name.capitalizingFirstLetter() ?? ""
    }
}


