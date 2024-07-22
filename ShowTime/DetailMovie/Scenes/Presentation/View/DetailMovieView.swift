//
//  DetailMovieView.swift
//  ShowTime
//
//  Created by MaurZac on 21/07/24.
//

import UIKit
import Combine

final class DetailMovieView: UIViewController {

        var viewModel: DetailMovieViewModel
        private var cancellables = Set<AnyCancellable>()
        private let favoriteMovieRepository: FavoriteMovieRepository
        
        init(viewModel: DetailMovieViewModel, favoriteMovieRepository: FavoriteMovieRepository) {
            self.viewModel = viewModel
            self.favoriteMovieRepository = favoriteMovieRepository
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private let scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            return scrollView
        }()
        
        private let contentView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        private let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        private let backButton: UIButton = {
            let button = UIButton(type: .system)
            let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold) // Cambia el tamaño de la imagen
            button.setImage(UIImage(systemName: "chevron.left.circle.fill", withConfiguration: configuration), for: .normal)
            button.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tintColor = .black
            return button
        }()
       
        private let favoriteButton: UIButton = {
            let button = UIButton(type: .system)
            let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
            let favoriteImage = UIImage(systemName: "bookmark.circle", withConfiguration: configuration)
            button.setImage(favoriteImage, for: .normal)
            button.setTitle("Agregar a mis favoritos", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            button.setTitleColor(.black, for: .normal)
            button.tintColor = .red
            button.imageView?.contentMode = .scaleAspectFit
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
            return button
        }()
        
        @objc private func addToFavorites() {
            print("Agregar a mis favoritos")
            viewModel.addMovieToFavorites()
            print("Movie added to favorites")
        }
        
        private let recipeNameLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let ratingStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 4
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        private let recipeDescriptionLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            setupBindings()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }
        
        private func setupUI() {
            view.backgroundColor = .white
            
            view.addSubview(scrollView)
            scrollView.addSubview(contentView)
            
            contentView.addSubview(imageView)
            contentView.addSubview(backButton)
            contentView.addSubview(recipeNameLabel)
            contentView.addSubview(ratingStackView)
            contentView.addSubview(recipeDescriptionLabel)
            contentView.addSubview(favoriteButton)
            
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                
                imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -140),
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                imageView.heightAnchor.constraint(equalToConstant: 300),
                
                backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -30),
                backButton.heightAnchor.constraint(equalToConstant: 100),
                backButton.widthAnchor.constraint(equalToConstant: 100),
                backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -4),
                
                recipeNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
                recipeNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                recipeNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
                
                ratingStackView.topAnchor.constraint(equalTo: recipeNameLabel.bottomAnchor, constant: 12),
                ratingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                
                recipeDescriptionLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 12),
                recipeDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                recipeDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
        
                favoriteButton.topAnchor.constraint(equalTo: recipeDescriptionLabel.bottomAnchor, constant: 20),
                favoriteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                favoriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ])
        }
        
        private func setupBindings() {
            viewModel.$posterImage
                .receive(on: DispatchQueue.main)
                .sink { [weak self] image in
                    self?.imageView.image = image
                }
                .store(in: &cancellables)
            
            viewModel.$movieTitle
                .receive(on: DispatchQueue.main)
                .sink { [weak self] name in
                    self?.recipeNameLabel.text = name
                }
                .store(in: &cancellables)
            
            viewModel.$overview
                .receive(on: DispatchQueue.main)
                .sink { [weak self] description in
                    self?.recipeDescriptionLabel.text = description
                }
                .store(in: &cancellables)
            
            viewModel.$starRating
                .receive(on: DispatchQueue.main)
                .sink { [weak self] rating in
                    self?.setupRatingStackView(with: rating)
                }
                .store(in: &cancellables)
        }
        
        private func setupRatingStackView(with rating: Int) {
            ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            let filledStarImage = UIImage(systemName: "star.fill")
            let emptyStarImage = UIImage(systemName: "star")
            
            for i in 0..<5 {
                let starImageView = UIImageView()
                starImageView.image = (i < rating) ? filledStarImage : emptyStarImage
                starImageView.contentMode = .scaleAspectFit
                ratingStackView.addArrangedSubview(starImageView)
            }
        }
        
        @objc private func popViewController() {
            navigationController?.popViewController(animated: true)
        }
    }
