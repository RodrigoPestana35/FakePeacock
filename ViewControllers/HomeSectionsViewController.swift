import UIKit
import Kingfisher

enum Category: String {
    case movies
    case tvShows
    
//    func getText() -> String {
//        switch self {
//        case .movies: "Movies"
//        case .tvShows: "TV Shows"
//        }
//    }
}

class HomeSectionsViewController: UIViewController{
    //view model para obter os dados para os rails
    private let homeViewModel = HomeSectionsViewModelImp()
    
    //botões para o header menu
    private let buttons = ["Home", "Movies", "TV Shows", "Sports", "WWE", "Olympics", "My Stuff"]
    
    //variavel que guarda os dados originais das rails obtidos
    private var items: [HomeSectionsRailsDto] = []
    //variavel que guarda os dados das rails apresentados na collectionView
    private var itemsShown: [HomeSectionsRailsDto] = [] {
        //esta função executa sempre que a variavel é alterada
        didSet{
            //atualiza os dados da collectionView
            collectionVW.reloadData()
        }
    }
    
    private var selectedImageTabBarView: UIImageView?
    private var selectedCategory: Category?
    private var selectedCellNameMenu: String?
    
    //Total number of cells
    private lazy var totalCels = buttons.count * 10_000
    
    //Rails Collection View
    private lazy var collectionVW: UICollectionView = {
        let collectionV = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionV.translatesAutoresizingMaskIntoConstraints = false
        collectionV.register(TileCollectionViewCell.self, forCellWithReuseIdentifier: TileCollectionViewCell.identifier)
        collectionV.register(TileHighlightCollectionViewCell.self, forCellWithReuseIdentifier: TileHighlightCollectionViewCell.identifier)
        collectionV.register(HeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSupplementaryView.identifier)
        collectionV.dataSource = self
        collectionV.delegate = self
        return collectionV
    }()
    //Header Menu Collection View
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
    
    private let tabBarMenu: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        label.layer.cornerRadius = 35
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    private let homeImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "house.fill")
        image.tintColor = .lightGray
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        return image
    }()
    private let tvImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "tv")
        image.tintColor = .lightGray
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        return image
    }()
    private let searchImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "magnifyingglass")
        image.tintColor = .lightGray
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        return image
    }()
    private let downloadImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "arrow.down")
        image.tintColor = .lightGray
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        return image
    }()
    private let perfilImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "person.circle")
        image.tintColor = .lightGray
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        return image
    }()
    private let peacockImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "p.circle")
        image.tintColor = .white
        image.contentMode = .scaleAspectFit
        return image
    }()
    private let chromecastImage: UIImageView = {
        let cast = UIImageView()
        cast.translatesAutoresizingMaskIntoConstraints = false
        cast.image = UIImage(systemName: "tv.badge.wifi")
        cast.tintColor = .white
        cast.contentMode = .scaleAspectFit
        return cast
    }()
    private let headerMenuLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(white: 1.0, alpha: 0)
        return label
    }()
    private let blurEffectHeaderMenu: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    private let blurEffectTabBar: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.alpha = 0.9
        blurEffectView.layer.cornerRadius = 35
        blurEffectView.layer.masksToBounds = true
        return blurEffectView
    }()
    
    // função que cria o layout com base no tipo de section
    func makeLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout.init(sectionProvider: { section, environment in
            if (self.items[section].renderHint?.template == "HIGHLIGHT") {
                return self.makeHighlightSection()
            }
            else {
                return self.makeRegularSection()
            }
        })
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .vertical
        configuration.interSectionSpacing = 60
        layout.configuration = configuration
        return layout
    }
    
    //função para criar uma section para rails normais
    func makeRegularSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 8, leading: 8, bottom: 0, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(250), heightDimension: .absolute(140))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(19))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        section.boundarySupplementaryItems = [headerItem]
        return section
    }
    
    //função para criar uma section para o highlight rail
    func makeHighlightSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(500))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 10
        return section
    }
    
    override func loadView() {
        super.loadView()
        
        //task para fazer pedido a API async
        Task{
            items = try await homeViewModel.execute()
            itemsShown = items
        }
        
    }
    
    override func viewDidLoad() {
        view.addSubview(collectionVW)
        collectionVW.backgroundColor = .black
        view.addSubview(headerMenuLabel)
        view.addSubview(blurEffectHeaderMenu)
        view.addSubview(menuCollectionView)
        view.addSubview(tabBarMenu)
        view.addSubview(blurEffectTabBar)
        view.addSubview(homeImage)
        view.addSubview(tvImage)
        view.addSubview(searchImage)
        view.addSubview(downloadImage)
        view.addSubview(perfilImage)
        view.addSubview(peacockImage)
        view.addSubview(chromecastImage)
        
        NSLayoutConstraint.activate([
            collectionVW.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionVW.topAnchor.constraint(equalTo: view.topAnchor, constant: -45),
            collectionVW.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionVW.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            menuCollectionView.leadingAnchor.constraint(equalTo: peacockImage.trailingAnchor),
            menuCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuCollectionView.trailingAnchor.constraint(equalTo: chromecastImage.leadingAnchor),
            menuCollectionView.heightAnchor.constraint(equalToConstant: 50),
            
            headerMenuLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerMenuLabel.topAnchor.constraint(equalTo: view.topAnchor),
            headerMenuLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerMenuLabel.bottomAnchor.constraint(equalTo: menuCollectionView.bottomAnchor, constant: 10),
            
            blurEffectHeaderMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectHeaderMenu.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectHeaderMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurEffectHeaderMenu.bottomAnchor.constraint(equalTo: menuCollectionView.bottomAnchor, constant: 10),
            
            peacockImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            peacockImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            peacockImage.widthAnchor.constraint(equalToConstant: 50),
            peacockImage.heightAnchor.constraint(equalToConstant: 50),
            
            chromecastImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            chromecastImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chromecastImage.widthAnchor.constraint(equalToConstant: 50),
            chromecastImage.heightAnchor.constraint(equalToConstant: 50),
            
            tabBarMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tabBarMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tabBarMenu.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            tabBarMenu.topAnchor.constraint(equalTo: view.topAnchor, constant: 730),
            
            blurEffectTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            blurEffectTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            blurEffectTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            blurEffectTabBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 730),
            
            homeImage.centerYAnchor.constraint(equalTo: tabBarMenu.centerYAnchor),
            homeImage.leadingAnchor.constraint(equalTo: tabBarMenu.leadingAnchor, constant: 40),
            homeImage.widthAnchor.constraint(equalToConstant: 30),
            homeImage.heightAnchor.constraint(equalToConstant: 30),
            
            tvImage.centerYAnchor.constraint(equalTo: tabBarMenu.centerYAnchor),
            tvImage.leadingAnchor.constraint(equalTo: homeImage.trailingAnchor, constant: 30),
            tvImage.widthAnchor.constraint(equalToConstant: 30),
            tvImage.heightAnchor.constraint(equalToConstant: 30),
            
            searchImage.centerYAnchor.constraint(equalTo: tabBarMenu.centerYAnchor),
            searchImage.leadingAnchor.constraint(equalTo: tvImage.trailingAnchor, constant: 30),
            searchImage.widthAnchor.constraint(equalToConstant: 30),
            searchImage.heightAnchor.constraint(equalToConstant: 30),
            
            downloadImage.centerYAnchor.constraint(equalTo: tabBarMenu.centerYAnchor),
            downloadImage.leadingAnchor.constraint(equalTo: searchImage.trailingAnchor, constant: 30),
            downloadImage.widthAnchor.constraint(equalToConstant: 30),
            downloadImage.heightAnchor.constraint(equalToConstant: 30),
            
            perfilImage.centerYAnchor.constraint(equalTo: tabBarMenu.centerYAnchor),
            perfilImage.leadingAnchor.constraint(equalTo: downloadImage.trailingAnchor, constant: 30),
            perfilImage.widthAnchor.constraint(equalToConstant: 30),
            perfilImage.heightAnchor.constraint(equalToConstant: 30),
            
        ])
        
        //adiciona comportamento aos botões da tabBar
        let homeTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTappedTabBar(_:)))
        homeImage.addGestureRecognizer(homeTapGesture)
        
        let tvTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTappedTabBar(_:)))
        tvImage.addGestureRecognizer(tvTapGesture)
        
        let searchTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTappedTabBar(_:)))
        searchImage.addGestureRecognizer(searchTapGesture)
        
        let downloadTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTappedTabBar(_:)))
        downloadImage.addGestureRecognizer(downloadTapGesture)
        
        let perfilTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTappedTabBar(_:)))
        perfilImage.addGestureRecognizer(perfilTapGesture)
        
        //selecionar por padrão a casinha na tabBar
        selectImageTabBar(imageView: homeImage)
        
        //selecionar por padrão o Home no headerMenu
        DispatchQueue.main.async {
            self.selectDefaultHeaderMenuItem()
        }
        
    }
    
    var controlo = 0
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if controlo == 0{
            let startItem: Int = totalCels/2
            menuCollectionView.scrollToItem(at: IndexPath(item: startItem, section: 0), at: .centeredHorizontally, animated: false)
            collectionVW.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            controlo=1
        }
        
    }
    
    //função chamada quando o utilizador clica nas imagens da TabBar
    @objc private func imageTappedTabBar(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }
        selectImageTabBar(imageView: tappedImageView)
    }
    
    //função que coloca e tira a linha por baixo da categoria e atualiza os dados apresentados
    private func selectLabelHeaderMenu(cell: MenuButtonCollectionViewCell, category: String) {
        //tira a linha da categoria anteriormente selecionada e diminui o tamanho da fonte
        menuCollectionView.visibleCells.forEach { currentCell in
            guard
                let selectedCellNameMenu,
                let castCell = currentCell as? MenuButtonCollectionViewCell
            else { return }
            if castCell.label.text == selectedCellNameMenu {
                castCell.showLine(false)
                castCell.label.font = UIFont.boldSystemFont(ofSize: 14)
            }
        }
        
        //aumenta o tamanho da fonte e seleciona a nova categoria
        cell.label.font = UIFont.boldSystemFont(ofSize: 16)
        cell.showLine(true)
        
        //com base na categoria selecionada atualiza a variavel dos dados apresentados com os dados filtrados para essa categoria
        switch(category) {
        case "Home":
            itemsShown = items
        case "Movies":
            itemsShown = filterCategory(category: "MOVIES")
        case "TV Shows":
            itemsShown = filterCategory(category: "ENTERTAINMENT")
        case "Sports":
            itemsShown = filterCategory(category: "SPORTS")
        default:
            itemsShown = items
        }
    }
    
    //função para filtrar os items pela categoria em cada rail
    private func filterCategory(category: String) -> [HomeSectionsRailsDto] {
        var data: [HomeSectionsRailsDto] = []
        let oldItems: [HomeSectionsRailsDto] = items
        oldItems.forEach { section in
            if let a = section.items {
                let filter = a.filter { $0.classification == category }
                if !filter.isEmpty {
                    let filteredSection = HomeSectionsRailsDto(type: section.type, items: filter, title: section.title, renderHint: section.renderHint)
                    data.append(filteredSection)
                }
            }
        }
        return data
    }
    
    //função para selecionar a categoria Home como default
    private func selectDefaultHeaderMenuItem() {
        let indexPath = IndexPath(item: totalCels/2, section: 0)
        if let cell = menuCollectionView.cellForItem(at: indexPath) as? MenuButtonCollectionViewCell {
            let category = buttons[0]
            selectLabelHeaderMenu(cell: cell, category: category)
            selectedCellNameMenu = cell.label.text
        }
    }
    
    //função para mostrar qual a imagem selecionada
    private func selectImageTabBar(imageView: UIImageView) {
        // tirar a imagem anteriormente selecionada
        if let selectedImageTabBarView = selectedImageTabBarView {
            selectedImageTabBarView.tintColor = .lightGray
            // Remove a linha amarela se existir
            if let underline = selectedImageTabBarView.viewWithTag(100) {
                underline.removeFromSuperview()
            }
        }
        
        // selecionar a nova imagem
        imageView.tintColor = .white
        selectedImageTabBarView = imageView
        
        // adicionar risca amarela por baixo
        let underlineView = UIView()
        underlineView.backgroundColor = UIColor(red: 1, green: 0.6588, blue: 0, alpha: 1.0)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.tag = 100
        underlineView.layer.cornerRadius = 2
        imageView.addSubview(underlineView)
        
        NSLayoutConstraint.activate([
            underlineView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -3),
            underlineView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 3),
            underlineView.bottomAnchor.constraint(equalTo: tabBarMenu.bottomAnchor, constant: -1),
            underlineView.heightAnchor.constraint(equalToConstant: 3)
        ])
    }
}

//extensão com os metodos para DelegateFlowLayout e DataSource
extension HomeSectionsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //Declarar o numero de cells em cada section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == menuCollectionView {
            return totalCels
        }
        else{
            return itemsShown[section].items?.count ?? 0
        }
    }
    
    //Adiciona o comportamento as celulas quando clicamos nelas
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == menuCollectionView {
            let category = buttons[indexPath.item % buttons.count]
            if let cell = collectionView.cellForItem(at: indexPath) as? MenuButtonCollectionViewCell {
                selectLabelHeaderMenu(cell: cell, category: category)
                selectedCellNameMenu = cell.label.text
//                let paths: [IndexPath] = [IndexPath(item: indexPath.item-1, section: 0), IndexPath(item: indexPath.item-2, section: 0), IndexPath(item: indexPath.item+1, section: 0), IndexPath(item: indexPath.item+2, section: 0)]
//                menuCollectionView.reloadItems(at: paths)
//                menuCollectionView.reloadData()
            }
        }
    }
    
    //Atribuição de valores as celulas das collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == menuCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuButtonCollectionViewCell.identifier, for: indexPath) as! MenuButtonCollectionViewCell
            cell.isUserInteractionEnabled = true
            if selectedCellNameMenu == buttons[indexPath.item % buttons.count] {
                cell.configure(title: buttons[indexPath.item % buttons.count], showLine: true)
                cell.label.font = UIFont.boldSystemFont(ofSize: 16)
            }
            else{
                cell.configure(title: buttons[indexPath.item % buttons.count], showLine: false)
                cell.label.font = UIFont.boldSystemFont(ofSize: 14)
            }
            return cell
        }
        else{
            if( itemsShown[indexPath.section].renderHint?.template == "HIGHLIGHT" ) {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TileHighlightCollectionViewCell.identifier, for: indexPath) as? TileHighlightCollectionViewCell {
                    let rail = itemsShown[indexPath.section]
                    guard let tile = rail.items?[indexPath.row]
                    else {
                        fatalError()
                    }
                    cell.configureImages(imageTileUrl: tile.images.first(where: { $0.type == "nonTitleArt34" || $0.type == "scene34" })?.url, titleImageURL: tile.images.first(where: { $0.type == "titleLogo" })?.url)
                    if tile.type == "ASSET/PROGRAMME" {
                        cell.configureTextLabel(genre: (tile.genreList?.first?.subgenre.first?.title ?? tile.classification) ?? "", year: tile.year ?? 0)
                    }
                    else if tile.type == "CATALOGUE/SERIES"{
                        cell.configureTextLabel(genre: (tile.genreList?.first?.subgenre.first?.title ?? tile.classification) ?? "", numberOfSeasons: tile.seasonCount ?? 0)
                    }
                    else if tile.type == "CATALOGUE/LINK" {
                        cell.configreTextLabel(description: tile.description ?? "")
                    }
                    else if tile.type == "ASSET/SLE" {
                        cell.configreTextLabel(description: tile.title)
                    }
                    return cell
                }
            }
            else {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TileCollectionViewCell.identifier, for: indexPath) as? TileCollectionViewCell {
                    let rail = itemsShown[indexPath.section]
                    guard let tile = rail.items?[indexPath.row]
                    else {
                        fatalError()
                    }
                    cell.configure(title: tile.title, imageUrl: tile.images.first(where: { $0.type == "landscape" || $0.type == "railBackground" })?.url)
                    return cell
                }
            }
        }
        fatalError()
    }
    
    // Declarar o numero de sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == menuCollectionView {
            return 1
        }
        else {
            return itemsShown.count
        }
    }
    
    //Função do delegate do Header Menu, calcula o tamanho da celula para aparecer todo o texto
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == menuCollectionView {
            let title = buttons[indexPath.item % buttons.count]
            let font = UIFont.boldSystemFont(ofSize: 14)
            let width = title.size(withAttributes: [NSAttributedString.Key.font: font]).width + 24
            return CGSize(width: width, height: 30)
        }
        else {
            return CGSize(width: 40, height: 30)
        }
    }
    
    //Adiciona os titulos aos headers
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSupplementaryView.identifier, for: indexPath) as? HeaderSupplementaryView else {
            fatalError()
        }
        headerView.configure(text: itemsShown[indexPath.section].title)
        return headerView
    }
    
    //É chamada sempre que ha scroll, calcula a percentagem de blur e opacidade da do header menu com base no scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let maxOffset = view.safeAreaLayoutGuide.layoutFrame.height / 3
        let percentage = min(0.5, contentOffsetY / maxOffset)+0.10
        headerMenuLabel.backgroundColor = UIColor(white: 0, alpha: percentage)
        blurEffectHeaderMenu.alpha = min(maxOffset, contentOffsetY) / maxOffset-0.1
    }
    
}
