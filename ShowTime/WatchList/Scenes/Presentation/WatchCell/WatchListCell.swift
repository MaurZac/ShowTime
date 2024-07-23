//
//  WatchListCell.swift
//  ShowTime
//
//  Created by MaurZac on 22/07/24.
//

import UIKit

final class WatchlistCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private var imageTask: URLSessionDataTask?
    
    private static let imageCache = NSCache<NSString, UIImage>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200) // Ajusta el alto
        ])
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        
        let posterUrlString = "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")"
        if let url = URL(string: posterUrlString) {
            imageTask?.cancel()
            
            if let cachedImage = WatchlistCell.imageCache.object(forKey: url.absoluteString as NSString) {
                imageView.image = cachedImage
            } else {
                loadImage(from: url)
            }
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
    
    private func loadImage(from url: URL) {
        imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error loading image: \(error)")
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(named: "placeholder")
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(named: "placeholder")
                }
                return
            }
            
            WatchlistCell.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            
            DispatchQueue.main.async {
                if let strongSelf = self, strongSelf.isImageVisible(for: url) {
                    strongSelf.imageView.image = image
                }
            }
        }
        imageTask?.resume()
    }
    
    private func isImageVisible(for url: URL) -> Bool {
        return imageView.image == nil || imageView.image == WatchlistCell.imageCache.object(forKey: url.absoluteString as NSString)
    }
}
