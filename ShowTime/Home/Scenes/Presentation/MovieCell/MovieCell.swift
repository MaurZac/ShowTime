//
//  MovieCell.swift
//  ShowTime
//
//  Created by MaurZac on 21/07/24.
//

import UIKit

final class MovieCell: UICollectionViewCell {
    
    static let identifier = "MovieCell"
    
    let posterImageView = UIImageView()
    private var imageDownloadTask: URLSessionDataTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 10
        posterImageView.layer.masksToBounds = true
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(posterImageView)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.image = nil
        imageDownloadTask?.cancel()
        imageDownloadTask = nil
    }
    func configure(with movie: String) {
        let imageUrlBase = "https://image.tmdb.org/t/p/"
        let imageSize = "original"
        let fullImageUrlString = "\(imageUrlBase)\(imageSize)\(movie)"
        
        if let imageUrl = URL(string: fullImageUrlString) {
            if let cachedImage = ImageCache.shared.getImage(forKey: imageUrl.absoluteString) {
                posterImageView.image = cachedImage
            } else {
                imageDownloadTask = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.posterImageView.image = image
                            ImageCache.shared.save(image: image, forKey: imageUrl.absoluteString)
                        }
                    } else {
                        print("DEBUG: error al descargar la imagen desde la URL: \(error?.localizedDescription ?? "error desconocido")")
                    }
                }
                imageDownloadTask?.resume()
            }
        }
    }
}

