//
//  BreedDetailViewController.swift
//  DailyDogs
//
//  Created by Ramona Cvelf on 31.03.21.
//

import Foundation
import UIKit
import SDWebImage

class BreedDetailViewController: UIViewController {
    private var breed: Breed?
    private var currentImageList: [String]?
    
    private let verticalStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .fill
        $0.isLayoutMarginsRelativeArrangement = true
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 6, trailing: 0)
        $0.spacing = 12
        
        return $0
    }(UIStackView())
    
    private let horizontalStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal

        return $0
    }(UIStackView())
    
    private let breedNameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .boldSystemFont(ofSize: 40)
        $0.textAlignment = .center

        return $0
    }(UILabel())
    
    private let breedImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        
        return $0
    }(UIImageView())
    
    private let subBreedPickerView: UIPickerView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UIPickerView())
    
    private let cancelButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .systemBlue
        $0.setImage(UIImage(systemName: "multiply")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 25)), for: .normal)

        return $0
    }(UIButton())
    
    private let randomImageButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .systemBlue
        $0.setImage(UIImage(systemName: "shuffle.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 25)), for: .normal)
        
        return $0
    }(UIButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subBreedPickerView.delegate = self
        subBreedPickerView.dataSource = self
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(cancelButton)
        horizontalStackView.addArrangedSubview(UIView())
        horizontalStackView.addArrangedSubview(randomImageButton)
        
        verticalStackView.addArrangedSubview(breedNameLabel)
        verticalStackView.addArrangedSubview(breedImageView)
        verticalStackView.addArrangedSubview(UIView())
        verticalStackView.addArrangedSubview(subBreedPickerView)
        
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo:  view.layoutMarginsGuide.trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            
            breedImageView.heightAnchor.constraint(equalToConstant: 90),
            breedImageView.widthAnchor.constraint(equalTo: breedImageView.heightAnchor)
        ])
        
        let cancelAction = UIAction{ [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
        cancelButton.addAction(cancelAction, for: .touchUpInside)
        
        let randomAction = UIAction{ [weak self] _ in
            guard let self = self else { return }
            self.setRandomImage()
        }
        randomImageButton.addAction(randomAction, for: .touchUpInside)
    }
    
    func configure(_ breed: Breed) {
        self.breed = breed
        
        if breed.subBreeds.count == 0 {
            subBreedPickerView.isHidden = true
            currentImageList = self.breed?.images
        } else {
            currentImageList = self.breed?.subBreeds[0].images
        }
        
        breedNameLabel.text = self.breed?.name.capitalizingFirstLetter() ?? ""

        setRandomImage()
    }
    
    private func setRandomImage() {
        breedImageView.sd_setImage(with: URL(string: self.currentImageList?.randomElement() ?? ""), placeholderImage: UIImage(named: "BreedImagePlaceholder"))
    }
}

extension BreedDetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breed?.subBreeds.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breed?.subBreeds[row].name
    }
}

extension BreedDetailViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let selectedSubBreed = self.breed?.subBreeds[row] {
            self.currentImageList = selectedSubBreed.images
            self.setRandomImage()
        }
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
