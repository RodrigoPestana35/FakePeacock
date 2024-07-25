import Foundation
import UIKit

class TopNavigationBarView: UIView {
    
    //botões para o header menu
    private let buttons = ["Home", "Movies", "TV Shows", "Sports", "WWE", "Olympics", "My Stuff"]
    
    //Total number of cells
    private lazy var totalCels = buttons.count * 10_000
    private var selectedCellNameMenu: String?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.clear.withAlphaComponent(0)
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.delaysContentTouches = false
        //        cv.isPagingEnabled = true
        cv.register(MenuButtonCollectionViewCell.self, forCellWithReuseIdentifier: MenuButtonCollectionViewCell.identifier)
        return cv
    }()
}

extension TopNavigationBarView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalCels
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuButtonCollectionViewCell.identifier, for: indexPath) as! MenuButtonCollectionViewCell
        cell.isUserInteractionEnabled = true
        if selectedCellNameMenu == buttons[indexPath.item % buttons.count] {
            cell.configure(title: buttons[indexPath.item % buttons.count])
//                cell.label.font = UIFont.boldSystemFont(ofSize: 16)
        }
        else{
            cell.configure(title: buttons[indexPath.item % buttons.count])
//                cell.label.font = UIFont.boldSystemFont(ofSize: 14)
        }
        return cell
    }
    
        
}
