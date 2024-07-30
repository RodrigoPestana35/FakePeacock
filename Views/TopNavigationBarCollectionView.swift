import UIKit

class TopNavigationBarCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    //botões para o header menu
    private let categories: [Category] = [.home , .movies, .tvShows, .sports, .wwe, .olympics, .myStuff, .olympics]
    
    private var selectedCellNameMenu: String?
    private var selectedCellIndexPath: IndexPath?
    
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    
    var delegateVar: FilterCategoryDelegate?
    
    init(frame: CGRect){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = .clear
        self.delegate = self
        self.dataSource = self
        self.showsHorizontalScrollIndicator = false
        self.register(TopNavigationBarCollectionViewCell.self, forCellWithReuseIdentifier: TopNavigationBarCollectionViewCell.identifier)
        
        DispatchQueue.main.async {
            self.selectDefaultHeaderMenuItem()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func selectDefaultHeaderMenuItem() {
        if let cell = self.cellForItem(at: IndexPath(row: 0, section: 0)) as? TopNavigationBarCollectionViewCell {
            delegateVar?.filterCategory(category: .home)
            selectedCellNameMenu = Category.home.getText()
            selectedCellIndexPath = IndexPath(row: 0, section: 0)
            select(row: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopNavigationBarCollectionViewCell.identifier, for: indexPath) as! TopNavigationBarCollectionViewCell
        cell.isUserInteractionEnabled = true
        if selectedCellNameMenu == categories[indexPath.item].getText() {
            cell.configureWithAlpha(title: categories[indexPath.item].getText(), alpha: 1)
        }
        else{
            cell.configureWithAlpha(title: categories[indexPath.item].getText(), alpha: 0.3)
        }
        return cell
    }
    
    //Adiciona o comportamento as celulas quando clicamos nelas
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self {
//            if let cell = collectionView.cellForItem(at: indexPath) as? TopNavigationBarCollectionViewCell {
                select(row: indexPath.item)
//            }
        }
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
    public func select(
        row: Int,
        in section: Int = 0,
        animated: Bool = true
    ) {
        // removes any selected items
        cleanupSelection()
        
        // set new selected item
        let indexPath = IndexPath(row: row, section: section)
        selectedCellIndexPath = indexPath
        
        // Update selected cell
        let cell = self.cellForItem(at: indexPath) as? TopNavigationBarCollectionViewCell
        cell?.configureWithAlpha(title: categories[indexPath.item].getText(), alpha: 1)
        
        if(selectedCellNameMenu != categories[indexPath.row].getText()){
            feedbackGenerator.selectionChanged()
            selectedCellNameMenu = categories[indexPath.row].getText()
            delegateVar?.filterCategory(category: categories[indexPath.row % categories.count])
        }
        
    }
    
    private func cleanupSelection() {
        guard let indexPath = selectedCellIndexPath else { return }
        let cell = self.cellForItem(at: indexPath) as? TopNavigationBarCollectionViewCell
        //        cell?.configure(title: buttons[indexPath.row % buttons.count], showLine: false)
        cell?.configureWithAlpha(title: categories[indexPath.row].getText(), alpha: 0.3)
        selectedCellIndexPath = nil
    }
    
}
