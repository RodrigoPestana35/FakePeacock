import UIKit

class TopMenuViewController: UIViewController, UICollectionViewDataSource {
    
    private let buttons = ["Home", "Movies", "TV Shows", "Sports", "WWE", "Olympics", "My Stuff"]
    
    private lazy var menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumInteritemSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.clear.withAlphaComponent(0)
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(MenuButtonCollectionViewCell.self, forCellWithReuseIdentifier: MenuButtonCollectionViewCell.identifier)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(menuCollectionView)
        
        NSLayoutConstraint.activate([
            menuCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            menuCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            menuCollectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1),
            menuCollectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        buttons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuButtonCollectionViewCell.identifier, for: indexPath) as! MenuButtonCollectionViewCell
        cell.configure(with: buttons[indexPath.row])
        return cell
    }
    
}
