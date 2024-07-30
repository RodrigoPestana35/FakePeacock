import UIKit

class TopNavigationBarCollectionViewCell: UICollectionViewCell {
    static let identifier = "TopNavigationBarCollectionViewCell"
    
    public var cateogry: Category?
        
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor(white: 1, alpha: 0.4)
        label.numberOfLines = 1
        return label
    }()
    
//    let underLine: UIView = {
//        let line = UIView()
//        line.backgroundColor = UIColor(red: 1, green: 0.6588, blue: 0, alpha: 1.0)
//        line.translatesAutoresizingMaskIntoConstraints = false
//        line.tag = 200
//        line.layer.cornerRadius = 2
//        return line
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(label)

//        self.contentView.addSubview(underLine)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
//            underLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
//            underLine.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2),
//            underLine.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 2),
//            underLine.heightAnchor.constraint(equalToConstant: 3)
        ])
        
//        underLine.isHidden = true
    }
    
    override func prepareForReuse() {
        label.text = nil
//        underLine.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func configure(
//        title: String,
//        showLine: Bool
//    ) {
//        label.text = "\(title)"
//        self.showLine(showLine)
//    }
    
    func configure(
        title: String
    ) {
        label.text = "\(title)"
    }
    
    func configureWithAlpha(title: String, alpha: CGFloat) {
        label.text = "\(title)"
        label.textColor = UIColor(white: 1, alpha: alpha)
    }
        
//    func showLine(_ showLine: Bool){
//        underLine.isHidden = !showLine
//    }
}
