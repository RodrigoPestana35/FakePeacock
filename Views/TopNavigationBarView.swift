import Foundation
import UIKit

enum Category: String {
    case home
    case movies
    case tvShows
    case sports
    case wwe
    case olympics
    case myStuff

    func getText() -> String {
        switch self {
        case .home: "Home"
        case .movies: "Movies"
        case .tvShows: "TV Shows"
        case .sports: "Sports"
        case .wwe: "WWE"
        case .olympics: "Olympics"
        case .myStuff: "My Stuff"
        }
    }
    
    func getCategory() -> String {
        if case .tvShows = self {
            return "ENTERTAINMENT"
        }
        else{
            return self.getText().uppercased().replacingOccurrences(of: " ", with: "")
        }
    }
}

class TopNavigationBarView: UIView {
    
    //botões para o header menu
    private let categories: [Category] = [ .home , .movies, .tvShows, .sports, .wwe, .olympics, .myStuff]
    
    //Total number of cells
    private lazy var totalCels = categories.count * 10_000
    
    private var selectedCellNameMenu: String?
    private var selectedCellIndexPath: IndexPath?
    
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    
    private var lastContentOffset: CGPoint = .zero
    private var lastUpdateTime: TimeInterval = 0
    private var scrollSpeed: CGFloat = 0 // Armazena a velocidade atual
    private var topHeaderIsCurrentScrolling = false
    
    var delegate: FilterCategoryDelegate?
    
    var firstTime = true
    lazy var menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumInteritemSpacing = 0
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(menuCollectionView)
        menuCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            menuCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            menuCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            menuCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        lastUpdateTime = CACurrentMediaTime()

        if firstTime {
            DispatchQueue.main.async {
                self.selectDefaultHeaderMenuItem()
                self.scrollViewDidScroll(self.menuCollectionView)
            }
            firstTime = false
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var control = true
    override func layoutSubviews() {
        super.layoutSubviews()
        print("SUBVIEWS")
        
        self.menuCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        if control {
            let startItem: Int = totalCels/2
            menuCollectionView.scrollToItem(at: IndexPath(item: startItem, section: 0), at: .centeredHorizontally, animated: false)
            control = false
        }
        
        
    }
    
    
    
    private func selectDefaultHeaderMenuItem() {
        print("DEFAULT")
        let indexPath = IndexPath(item: totalCels/2, section: 0)
        if let cell = menuCollectionView.cellForItem(at: indexPath) as? MenuButtonCollectionViewCell {
            delegate?.filterCategory(category: .home)
            selectedCellNameMenu = cell.label.text
            selectedCellIndexPath = indexPath
        }
    }
}

extension TopNavigationBarView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalCels
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuButtonCollectionViewCell.identifier, for: indexPath) as! MenuButtonCollectionViewCell
        cell.isUserInteractionEnabled = true
        if selectedCellNameMenu == categories[indexPath.item % categories.count].getText() {
            cell.configure(title: categories[indexPath.item % categories.count].getText())
            //                cell.label.font = UIFont.boldSystemFont(ofSize: 16)
        }
        else{
            cell.configure(title: categories[indexPath.item % categories.count].getText())
            //                cell.label.font = UIFont.boldSystemFont(ofSize: 14)
        }
        return cell
    }
    
    //Adiciona o comportamento as celulas quando clicamos nelas
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == menuCollectionView {
            let category = categories[indexPath.item % categories.count]
            if let cell = collectionView.cellForItem(at: indexPath) as? MenuButtonCollectionViewCell {
                select(row: indexPath.item)
            }
        }
    }
    
    //Função do delegate do Header Menu, calcula o tamanho da celula para aparecer todo o texto
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = categories[indexPath.item % categories.count].getText()
        let font = UIFont.boldSystemFont(ofSize: 15)
        let width = title.size(withAttributes: [NSAttributedString.Key.font: font]).width + 24
        return CGSize(width: width, height: 30)
        //        return CGSize(width: 70, height: collectionView.frame.height)
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollToCell()
        }
        topHeaderIsCurrentScrolling = true
    }
    
    //É chamada sempre que ha scroll, calcula a percentagem de blur e opacidade da do header menu com base no scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = scrollView.bounds.size.width/2 + scrollView.contentOffset.x
        for cell in menuCollectionView.visibleCells as! [MenuButtonCollectionViewCell] {
            let cellCenterX = cell.center.x
            let distanceFromCenter = abs(centerX - cellCenterX)
            let maxDistance = scrollView.bounds.size.width/2
            let percentage = min(distanceFromCenter / maxDistance, 1)
            let maxFontSize: CGFloat = 20
            let minFontSize: CGFloat = 14
            let fontSize = maxFontSize - ((maxFontSize - minFontSize) * percentage)
            let alpha = 0.3 + ((1 - 0.3) * (1 - percentage))
            cell.label.font = UIFont.boldSystemFont(ofSize: fontSize)
            cell.label.alpha = alpha
        }
        let currentTime = CACurrentMediaTime()
        let deltaTime = currentTime - lastUpdateTime
        let deltaOffset = scrollView.contentOffset.x - lastContentOffset.x
        
        // Calcula a velocidade (pixels por segundo)
        scrollSpeed = abs(deltaOffset / CGFloat(deltaTime))
        
        // Atualiza o tempo e deslocamento anteriores
        lastUpdateTime = currentTime
        lastContentOffset = scrollView.contentOffset
        
        if topHeaderIsCurrentScrolling == true {
            if(scrollSpeed <= 100 && scrollSpeed != 0) {
                scrollToCell()
                topHeaderIsCurrentScrolling = false
            }
        }
    }
    
}

// HomeSectionsViewController(TopNavigationBarView)
// TopNavigationBarView -> HomeSectionsViewController
protocol FilterCategoryDelegate {
    func filterCategory(category: Category)
}



extension TopNavigationBarView {
    public func select(
        row: Int,
        in section: Int = 0,
        animated: Bool = true
    ) {
        // Ensures selected row isnt more then data count
        guard row < totalCels else { return }
        
        // removes any selected items
        cleanupSelection()
        
        // set new selected item
        let indexPath = IndexPath(row: row, section: section)
        selectedCellIndexPath = indexPath
        
        // Update selected cell
        let cell = menuCollectionView.cellForItem(at: indexPath) as? MenuButtonCollectionViewCell
        cell?.configure(
            title: categories[indexPath.row % categories.count].getText()
            //            showLine: true
        )
        
        if(selectedCellNameMenu != categories[indexPath.row % categories.count].getText()){
            feedbackGenerator.selectionChanged()
            selectedCellNameMenu = categories[indexPath.row % categories.count].getText()
            delegate?.filterCategory(category: categories[indexPath.row % categories.count])
        }
        
        menuCollectionView.selectItem(
            at: indexPath,
            animated: animated,
            scrollPosition: .centeredHorizontally)
        
    }
    
    private func cleanupSelection() {
        guard let indexPath = selectedCellIndexPath else { return }
        let cell = menuCollectionView.cellForItem(at: indexPath) as? MenuButtonCollectionViewCell
        //        cell?.configure(title: buttons[indexPath.row % buttons.count], showLine: false)
        cell?.configure(title: categories[indexPath.row % categories.count].getText())
        selectedCellIndexPath = nil
//        selectedCellNameMenu = ""
    }
    
    private func scrollToCell() {
        var indexPath = IndexPath()
        var visibleCells = menuCollectionView.visibleCells
        
        visibleCells = visibleCells.filter({ cell -> Bool in
            let cellRect = menuCollectionView.convert(
                cell.frame,
                to: self
            )
            let viewMidX = self.bounds.midX
            let cellMidX = cellRect.midX
            let topBoundary = viewMidX + cellRect.width/2
            let bottomBoundary = viewMidX - cellRect.width/2
            
            return topBoundary > cellMidX  && cellMidX > bottomBoundary
        })
        
        if visibleCells.isEmpty == true {
            visibleCells.append(menuCollectionView.visibleCells[abs(menuCollectionView.visibleCells.count/2)])
        }
        
        visibleCells.forEach({
            if let selectedIndexPath = menuCollectionView.indexPath(for: $0) {
                indexPath = selectedIndexPath
            }
        })
        
        self.select(row: indexPath.row)
    }
    
}
