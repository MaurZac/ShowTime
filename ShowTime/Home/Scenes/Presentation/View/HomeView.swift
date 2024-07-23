//
//  HomeView.swift
//  ShowTime
//
//  Created by MaurZac on 20/07/24.
//

import UIKit
import Combine

private enum CollectionViewStyle {
    case grid
    case list
}

final class HomeViewController: UIViewController, UISearchBarDelegate, UIScrollViewDelegate {
    
    private var viewModel: HomeViewModel!
    private var cancellables = Set<AnyCancellable>()
    private var lastContentOffset: CGFloat = 0
    
    private let searchBar = UISearchBar()
    private var collectionView: UICollectionView!
    private var secondCollectionView: UICollectionView!
    var coordinator: HomeViewCoordinator?
    private var viewControllerFactory: HomeViewControllerFactory!
    private var collectionViewStyle: CollectionViewStyle = .grid
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let repository = HomeMovieRepositoryImp()
        let fetchMovieUseCase = HomeMovieUseCase(repository: repository)
        viewModel = HomeViewModel(fetchMovieUseCase: fetchMovieUseCase)
        view.isUserInteractionEnabled = true
        
        setupUI()
        setupBindings()
        
    }
    
    private func changeCollectionViewStyle(to style: CollectionViewStyle) {
        collectionViewStyle = style
        
        let layout: UICollectionViewFlowLayout
        
        switch style {
        case .grid:
            layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 8, left: 12, bottom: 0, right: 12)
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
        case .list:
            layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
        
        secondCollectionView.setCollectionViewLayout(layout, animated: true)
        secondCollectionView.reloadData()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        let headerLabel = UILabel()
        headerLabel.text = "¿Qué quieres ver hoy?"
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerLabel)
        
        let popularTitle = UILabel()
        popularTitle.text = "Las mas populares"
        popularTitle.textAlignment = .left
        popularTitle.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        popularTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(popularTitle)
        
        let nowPlaying = UILabel()
        nowPlaying.text = "Reproduciendo ahora"
        nowPlaying.textAlignment = .left
        nowPlaying.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        nowPlaying.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nowPlaying)
        
        searchBar.delegate = self
        searchBar.placeholder = "Buscar..."
        searchBar.tintColor = .systemBlue
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.alpha = 1
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.layer.borderColor = UIColor.white.cgColor
        searchBar.searchTextField.layer.borderWidth = 0
        searchBar.searchTextField.layer.cornerRadius = 20
        searchBar.barTintColor = UIColor.white
        searchBar.searchTextField.tintColor = UIColor.white
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.borderStyle = .roundedRect
        navigationItem.titleView = searchBar
        
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        
        view.addSubview(searchBar)
        
        
        let settingsButton = UIButton(type: .system)
        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        settingsButton.tintColor = .systemBlue
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.showsMenuAsPrimaryAction = true
        let listAction = UIAction(title: "List View") { _ in
            self.changeCollectionViewStyle(to: .list)
        }
        let gridAction = UIAction(title: "Grid View") { _ in
            self.changeCollectionViewStyle(to: .grid)
        }
        settingsButton.menu = UIMenu(title: "View Options", children: [listAction, gridAction])
        view.addSubview(settingsButton)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal  // Configura la colección para que sea horizontal
        layout.sectionInset = UIEdgeInsets(top: 8, left: 12, bottom: 0, right: 12)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        let secondLayout = UICollectionViewFlowLayout()
        secondLayout.scrollDirection = .vertical
        secondLayout.sectionInset = UIEdgeInsets(top: 8, left: 12, bottom: 0, right: 12)
        secondLayout.minimumInteritemSpacing = 8
        secondLayout.minimumLineSpacing = 8
        
        secondCollectionView = UICollectionView(frame: .zero, collectionViewLayout: secondLayout)
        secondCollectionView.dataSource = self
        secondCollectionView.delegate = self
        secondCollectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        secondCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(secondCollectionView)
        
        NSLayoutConstraint.activate([
            
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -40),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            searchBar.topAnchor.constraint(equalTo: headerLabel.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            
            settingsButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            settingsButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 6),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 6),
            
            popularTitle.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            popularTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            collectionView.topAnchor.constraint(equalTo: popularTitle.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 220),
            
            nowPlaying.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            nowPlaying.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            secondCollectionView.topAnchor.constraint(equalTo: nowPlaying.bottomAnchor, constant: 16),
            secondCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            secondCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            secondCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.$filteredMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$filteredNowPlaying
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.secondCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$searchText
            .sink { [weak self] searchText in
                self?.searchBar.text = searchText
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchMovies(with: searchBar.text ?? "")
        view.endEditing(true)
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset.y
        view.endEditing(true)
    }
    
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionView {
            return viewModel.filteredMovies.count
        } else if collectionView == self.secondCollectionView {
            return viewModel.filteredNowPlaying.count 
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        if collectionView == self.collectionView {
            let movie = viewModel.filteredMovies[indexPath.item].posterPath ?? "desconocido"
            cell.configure(with: movie)
        } else if collectionView == self.secondCollectionView {
            let movie = viewModel.filteredNowPlaying[indexPath.item].posterPath ?? "desconocido"
            cell.configure(with: movie)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            let collectionViewWidth = collectionView.frame.width
            let numberOfItemsPerRow: CGFloat = 3
            let totalSpacing = (numberOfItemsPerRow - 1) * 15
            let itemWidth = (collectionViewWidth - totalSpacing) / numberOfItemsPerRow
            let itemHeight: CGFloat = 180
            return CGSize(width: itemWidth, height: itemHeight)
        } else if collectionView == self.secondCollectionView {
            let collectionViewWidth = collectionView.frame.width
            switch collectionViewStyle {
            case .grid:
                let itemWidth = (collectionViewWidth - 32) / 2
                let itemHeight: CGFloat = 250
                return CGSize(width: itemWidth, height: itemHeight)
            case .list:
                return CGSize(width: collectionViewWidth - 32, height: 150) 
            }
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func handleRecipeSelection(_ movie: Movie) {
        coordinator?.navigateToDetailMovie(movie: movie)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let selectedMovie = viewModel.filteredMovies[indexPath.row]
            handleRecipeSelection(selectedMovie)
        } else if collectionView == self.secondCollectionView {
            let selectedMovie = viewModel.filteredNowPlaying[indexPath.row]
            handleRecipeSelection(selectedMovie)
        }
    }
}
