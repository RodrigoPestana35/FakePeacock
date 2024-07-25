import Foundation
import UIKit

class TileCollectionViewCell: UICollectionViewCell {
    static let identifier = "TileCollectionViewCell"
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.zPosition = 1
        let backColor = UIColor(red: 0.2392, green: 0.2392, blue: 0.2392, alpha: 0.8)
        label.backgroundColor = backColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 9
        label.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return label
    }()
    
    private var imageTile: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 9
        image.layer.masksToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .red
        self.layer.cornerRadius = 9
        self.addSubview(titleLabel)
        self.addSubview(imageTile)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: imageTile.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageTile.topAnchor, constant: 110),
            titleLabel.trailingAnchor.constraint(equalTo: imageTile.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: imageTile.bottomAnchor),
            imageTile.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageTile.topAnchor.constraint(equalTo: self.topAnchor),
            imageTile.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageTile.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func configure(title:String? , imageUrl: String? ) -> Void{
        if let imageUrl, let url = URL(string: imageUrl){
            imageTile.kf.setImage(with: url)
        }

        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
