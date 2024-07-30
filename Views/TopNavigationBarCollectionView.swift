import UIKit

class TopNavigationBarCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    //botões para o header menu
    private let categories: [Category] = [ .home , .movies, .tvShows, .sports, .wwe, .olympics, .myStuff]
    
    private var selectedCellNameMenu: String?
    private var selectedCellIndexPath: IndexPath?
    
    
    init(frame: CGRect){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = .clear
        self.delegate = self
        self.dataSource = self
        self.showsHorizontalScrollIndicator = false
        self.register(TopNavigationBarCollectionViewCell.self, forCellWithReuseIdentifier: TopNavigationBarCollectionViewCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopNavigationBarCollectionViewCell.identifier, for: indexPath) as! TopNavigationBarCollectionViewCell
        cell.isUserInteractionEnabled = true
        if selectedCellNameMenu == categories[indexPath.item].getText() {
            cell.configure(title: categories[indexPath.item].getText())
        }
        else{
            cell.configure(title: categories[indexPath.item].getText())
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = categories[indexPath.item].getText()
        let font = UIFont.boldSystemFont(ofSize: 18)
        let width = title.size(withAttributes: [NSAttributedString.Key.font: font]).width + 12
        return CGSize(width: width, height: 30)
        //        return CGSize(width: 70, height: collectionView.frame.height)
    }
    
    
}
extension TopNavigationBarCollectionView {
//    public func select(
//        row: Int,
//        in section: Int = 0,
//        animated: Bool = true
//    ) {
//        // removes any selected items
//        cleanupSelection()
//        
//        // set new selected item
//        let indexPath = IndexPath(row: row, section: section)
//        selectedCellIndexPath = indexPath
//        
//        // Update selected cell
//        let cell = menuCollectionView.cellForItem(at: indexPath) as? MenuButtonCollectionViewCell
//        cell?.configure(
//            title: categories[indexPath.row % categories.count].getText()
//            //            showLine: true
//        )
//        
//        if(selectedCellNameMenu != categories[indexPath.row % categories.count].getText()){
//            feedbackGenerator.selectionChanged()
//            selectedCellNameMenu = categories[indexPath.row % categories.count].getText()
//            delegate?.filterCategory(category: categories[indexPath.row % categories.count])
//        }
//        
//        menuCollectionView.selectItem(
//            at: indexPath,
//            animated: animated,
//            scrollPosition: .centeredHorizontally)
//        
//    }
    
//    private func cleanupSelection() {
//        guard let indexPath = selectedCellIndexPath else { return }
//        let cell = menuCollectionView.cellForItem(at: indexPath) as? MenuButtonCollectionViewCell
//        //        cell?.configure(title: buttons[indexPath.row % buttons.count], showLine: false)
//        cell?.configure(title: categories[indexPath.row % categories.count].getText())
//        selectedCellIndexPath = nil
////        selectedCellNameMenu = ""
    }
    
//    private func scrollToCell() {
//        var indexPath = IndexPath()
//        var visibleCells = menuCollectionView.visibleCells
//        
//        visibleCells = visibleCells.filter({ cell -> Bool in
//            let cellRect = menuCollectionView.convert(
//                cell.frame,
//                to: self
//            )
//            let viewMidX = self.bounds.midX
//            let cellMidX = cellRect.midX
//            let topBoundary = viewMidX + cellRect.width/2
//            let bottomBoundary = viewMidX - cellRect.width/2
//            
//            return topBoundary > cellMidX  && cellMidX > bottomBoundary
//        })
//        
//        if visibleCells.isEmpty == true {
//            visibleCells.append(menuCollectionView.visibleCells[abs(menuCollectionView.visibleCells.count/2)])
//        }
//        
//        visibleCells.forEach({
//            if let selectedIndexPath = menuCollectionView.indexPath(for: $0) {
//                indexPath = selectedIndexPath
//            }
//        })
//        
//        self.select(row: indexPath.row)
//    }
    
//}
