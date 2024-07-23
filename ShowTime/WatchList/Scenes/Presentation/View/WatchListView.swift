//
//  WatchListView.swift
//  ShowTime
//
//  Created by MaurZac on 22/07/24.
//

import UIKit
import Combine

final class WatchlistView: UIViewController, UICollectionViewDelegate {

        private let collectionView: UICollectionView
        private let viewModel: WatchlistViewModel
        private var cancellables = Set<AnyCancellable>()
        
        private let emptyLabel: UILabel = {
            let label = UILabel()
            label.text = "Agrega a favoritos"
            label.textColor = .gray
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            label.numberOfLines = 0
            return label
        }()
        
        private let titleLabel: UILabel = {
            let title = UILabel()
            title.text = "Lista de favoritos"
            title.textColor = .gray
            title.textAlignment = .center
            title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            title.numberOfLines = 1
            return title
        }()
        
        init(viewModel: WatchlistViewModel) {
            self.viewModel = viewModel
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let screenWidth = UIScreen.main.bounds.width
            let itemWidth = (screenWidth - 24) / 2
            layout.itemSize = CGSize(width: itemWidth, height: 200 + 40)
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
            self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            setupCollectionView()
            setupEmptyLabel()
            setupBindings()
        }
        
        private func setupCollectionView() {
            collectionView.backgroundColor = .white
            collectionView.register(WatchlistCell.self, forCellWithReuseIdentifier: "WatchlistCell")
            collectionView.dataSource = self
            collectionView.delegate = self
            
            view.addSubview(titleLabel)
            view.addSubview(collectionView)
            
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                titleLabel.heightAnchor.constraint(equalToConstant: 40),
                
                collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        
        private func setupEmptyLabel() {
            view.addSubview(emptyLabel)
            
            emptyLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                emptyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
                emptyLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
            ])
            
            emptyLabel.isHidden = true
        }
        
        private func setupBindings() {
            viewModel.$movies
                   .receive(on: DispatchQueue.main)
                   .sink { [weak self] movies in
                       self?.collectionView.reloadData()
                       self?.emptyLabel.isHidden = !movies.isEmpty
                   }
                   .store(in: &cancellables)
        }
    }

    // MARK: - UICollectionViewDataSource
    extension WatchlistView: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewModel.movies.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WatchlistCell", for: indexPath) as! WatchlistCell
            let movie = viewModel.movies[indexPath.item]
            cell.configure(with: movie)
            return cell
        }
    }
