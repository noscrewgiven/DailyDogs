//
//  BreedfeedController.swift
//  DailyDogs
//
//  Created by Ramona Cvelf on 31.03.21.
//

import Foundation
import UIKit

enum Section {
    case allbreeds
}

class BreedfeedController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Breed>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Breed>
    typealias SnapshotDogOfTheDay = NSDiffableDataSourceSnapshot<Section, String>
    
    private lazy var dataSource = makeDataSource()
    var breedModel = BreedModel()
    
    let collectionView: UICollectionView = {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = true
        
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(BreedViewCell.self, forCellWithReuseIdentifier: "allbreedscell")
        
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Daily Dogs"
        collectionView.delegate = self
        setupUI()
        
        breedModel.loadBreedsFromApi {
            self.breedModel.loadImagesForBreedsAndSubBreeds(count: 10) {
                self.applySnapshot()
            }
        }
        self.applySnapshot()
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, breed) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allbreedscell", for: indexPath) as? BreedViewCell else { return nil }
            
            cell.configure(breed)
            return cell
        })
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.allbreeds])
        snapshot.appendItems(breedModel.breeds)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension BreedfeedController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? BreedViewCell,
              let selectedBreed = selectedCell.breed
        else { return }
        
        if !selectedBreed.didLoadImagesFromApi {
            return
        }
        
        let detailViewController = BreedDetailViewController()
        detailViewController.configure(selectedBreed)
        
        navigationController?.present(detailViewController, animated: true)
    }
}
