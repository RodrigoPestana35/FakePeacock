import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeCustomCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        //        let url = URL(string: home)
        //            if let data = try? Data(contentsOf: url!)
        //            {
        //              let image: UIImage = UIImage(data: data)
        //            }
        iv.image = UIImage(systemName: "questionmark")
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    public func configure(with image: UIImage) {
        self.imageView.image = image
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = .purple
        
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
