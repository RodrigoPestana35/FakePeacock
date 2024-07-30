import UIKit

class TileHighlightCollectionViewCell: UICollectionViewCell {
    static let identifier = "TileHighlightCollectionViewCell"
    
    private var imageTile: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let gradientLayerDown: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(1).cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
        return gradientLayer
    }()
    
    private let gradientLayerUp: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(1).cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.20)
        return gradientLayer
    }()
    
    private var titleImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
//        image.layer.shadowColor = UIColor.black.cgColor
//        image.layer.shadowOpacity = 0.7
//        image.layer.shadowOffset = CGSize(width: 0, height: -5)
        return image
    }()
    
    private var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        label.font = label.font.withSize(14)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byClipping
        return label
    }()
    
    private var watchButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("WATCH", for: .normal)
        button.tintColor = .white
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = button.titleLabel?.font.withSize(13)
        button.backgroundColor = UIColor(red: 0.349, green: 0.349, blue: 0.349, alpha: 0.4)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(red: 0.0667, green: 0.0667, blue: 0.0667, alpha: 1.0)
        self.layer.cornerRadius = 9
        self.addSubview(imageTile)
        self.addSubview(titleImage)
        self.addSubview(infoLabel)
        self.addSubview(watchButton)
        
        NSLayoutConstraint.activate([
            imageTile.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageTile.topAnchor.constraint(equalTo: self.topAnchor),
            imageTile.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageTile.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            titleImage.leadingAnchor.constraint(equalTo: imageTile.leadingAnchor, constant: 60),
            titleImage.topAnchor.constraint(equalTo: imageTile.topAnchor, constant: 270),
            titleImage.trailingAnchor.constraint(equalTo: imageTile.trailingAnchor, constant: -60),
            titleImage.bottomAnchor.constraint(equalTo: imageTile.bottomAnchor, constant: -120),
            
            infoLabel.leadingAnchor.constraint(equalTo: titleImage.leadingAnchor, constant: 50),
            infoLabel.topAnchor.constraint(equalTo: titleImage.bottomAnchor, constant: 10),
            infoLabel.trailingAnchor.constraint(equalTo: titleImage.trailingAnchor, constant: -50),
            infoLabel.bottomAnchor.constraint(equalTo: imageTile.bottomAnchor, constant: -70),
            
            watchButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            watchButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10),
            watchButton.widthAnchor.constraint(equalToConstant: 120),
            watchButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        imageTile.layer.addSublayer(gradientLayerDown)
        imageTile.layer.addSublayer(gradientLayerUp)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayerDown.frame = imageTile.bounds
        gradientLayerUp.frame = imageTile.bounds
    }
    
    func configureImages(imageTileUrl: String?, titleImageURL: String? ) -> Void {
        if let imageTileUrl, let url1 = URL(string: imageTileUrl){
            imageTile.kf.setImage(with: url1)
        }
        if let titleImageURL, let url2 = URL(string: titleImageURL){
            titleImage.kf.setImage(with: url2)
        }
    }
    
    func configureTextLabel(genre: String, numberOfSeasons: Int) -> Void {
        if numberOfSeasons == 1 {
            infoLabel.text = "\(genre) • \(String(numberOfSeasons)) season"
        }
        else{
            infoLabel.text = "\(genre) • \(String(numberOfSeasons)) seasons"
        }
        
    }
    
    func configureTextLabel(genre: String, year: Int) -> Void {
        infoLabel.text = "\(genre) • \(String(year))"
    }
    
    func configreTextLabel(description: String) -> Void {
        infoLabel.text = "\(description)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
