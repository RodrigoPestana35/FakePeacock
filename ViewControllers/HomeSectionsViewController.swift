import UIKit
import Kingfisher

class HomeSectionsViewController: UIViewController, FilterCategoryDelegate{
    //view model para obter os dados para os rails
    private let homeViewModel = HomeSectionsViewModelImp()
    
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
    
    private let topNavigationBar = TopNavigationBarView()
    private var topNavigationBarCollectionView: TopNavigationBarCollectionView!
    
    private var typeHighlightedImage: String = ""
    
    private var selectedImageTabBarView: UIImageView?
    private var selectedCellNameMenu: String?
    private var selectedCellIndexPath: IndexPath?
    
    private var lastContentOffset: CGPoint = .zero
    private var lastUpdateTime: TimeInterval = 0
    private var scrollSpeed: CGFloat = 0 // Armazena a velocidade atual
    private var topHeaderIsCurrentScrolling = false
    
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
        image.image = UIImage(named: "peacockLogoShort")
        image.tintColor = .white
        image.contentMode = .scaleAspectFit
        return image
    }()
    private let chromecastImage: UIImageView = {
        let cast = UIImageView()
        cast.translatesAutoresizingMaskIntoConstraints = false
        cast.image = UIImage(named: "chromecast_icon_white")
        cast.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
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
        configuration.interSectionSpacing = 40
        layout.configuration = configuration
        return layout
    }
    
    //função para criar uma section para rails normais
    func makeRegularSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 8, leading: 3, bottom: 0, trailing: 3)
        let groupSize: NSCollectionLayoutSize
        if UITraitCollection.current.horizontalSizeClass == .regular && UITraitCollection.current.verticalSizeClass == .regular {
            groupSize = NSCollectionLayoutSize(widthDimension: .absolute(300), heightDimension: .absolute(168))
        }
        else {
            groupSize = NSCollectionLayoutSize(widthDimension: .absolute(250), heightDimension: .absolute(140))
        }
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 4
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
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func loadView() {
        super.loadView()
        
        //task para fazer pedido a API async
        Task{
            items = try await homeViewModel.execute()
            itemsShown = items
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupCollectioViews()
        print("AAAAAAA")
    }
    
    override func viewDidLoad() {
        print("BBBBBBBBB")
        
        view.addSubview(collectionVW)
        collectionVW.backgroundColor = .black
        view.addSubview(headerMenuLabel)
        view.addSubview(blurEffectHeaderMenu)
        topNavigationBar.delegate = self
        topNavigationBarCollectionView = TopNavigationBarCollectionView(frame: self.view.bounds)
        topNavigationBarCollectionView.delegateVar = self
        topNavigationBarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        topNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        topNavigationBar.isHidden = true
        self.view.addSubview(topNavigationBar)
        self.view.addSubview(topNavigationBarCollectionView)
        view.addSubview(tabBarMenu)
        view.addSubview(blurEffectTabBar)
        view.addSubview(homeImage)
        view.addSubview(tvImage)
        view.addSubview(searchImage)
        view.addSubview(downloadImage)
        view.addSubview(perfilImage)
        view.addSubview(peacockImage)
        view.addSubview(chromecastImage)
                
        if UITraitCollection.current.horizontalSizeClass == .regular && UITraitCollection.current.verticalSizeClass == .regular {
            print("TABLET")
            typeHighlightedImage = "landscape"
            NSLayoutConstraint.activate([
                tabBarMenu.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                tabBarMenu.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
                tabBarMenu.widthAnchor.constraint(equalToConstant: 600),
                tabBarMenu.heightAnchor.constraint(equalToConstant: 80),
                
                blurEffectTabBar.leadingAnchor.constraint(equalTo: tabBarMenu.leadingAnchor),
                blurEffectTabBar.trailingAnchor.constraint(equalTo: tabBarMenu.trailingAnchor),
                blurEffectTabBar.bottomAnchor.constraint(equalTo: tabBarMenu.bottomAnchor),
                blurEffectTabBar.topAnchor.constraint(equalTo: tabBarMenu.topAnchor),
                
                homeImage.centerYAnchor.constraint(equalTo: tabBarMenu.centerYAnchor),
                homeImage.leadingAnchor.constraint(equalTo: tabBarMenu.leadingAnchor, constant: 66),
                homeImage.widthAnchor.constraint(equalToConstant: 40),
                homeImage.heightAnchor.constraint(equalToConstant: 40),
                
                tvImage.centerYAnchor.constraint(equalTo: tabBarMenu.centerYAnchor),
                tvImage.leadingAnchor.constraint(equalTo: homeImage.trailingAnchor, constant: 66),
                tvImage.widthAnchor.constraint(equalToConstant: 40),
                tvImage.heightAnchor.constraint(equalToConstant: 40),
                
                searchImage.centerYAnchor.constraint(equalTo: tabBarMenu.centerYAnchor),
                searchImage.leadingAnchor.constraint(equalTo: tvImage.trailingAnchor, constant: 66),
                searchImage.widthAnchor.constraint(equalToConstant: 40),
                searchImage.heightAnchor.constraint(equalToConstant: 40),
                
                downloadImage.centerYAnchor.constraint(equalTo: tabBarMenu.centerYAnchor),
                downloadImage.leadingAnchor.constraint(equalTo: searchImage.trailingAnchor, constant: 66),
                downloadImage.widthAnchor.constraint(equalToConstant: 40),
                downloadImage.heightAnchor.constraint(equalToConstant: 40),
                
                perfilImage.centerYAnchor.constraint(equalTo: tabBarMenu.centerYAnchor),
                perfilImage.leadingAnchor.constraint(equalTo: downloadImage.trailingAnchor, constant: 66),
                perfilImage.widthAnchor.constraint(equalToConstant: 40),
                perfilImage.heightAnchor.constraint(equalToConstant: 40),
            ])
        }
        else{
            print("IPHONE")
            typeHighlightedImage = "nonTitleArt34"
            NSLayoutConstraint.activate([
                tabBarMenu.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                tabBarMenu.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
                tabBarMenu.widthAnchor.constraint(equalToConstant: 350),
                tabBarMenu.heightAnchor.constraint(equalToConstant: 70),
                
                blurEffectTabBar.leadingAnchor.constraint(equalTo: tabBarMenu.leadingAnchor),
                blurEffectTabBar.trailingAnchor.constraint(equalTo: tabBarMenu.trailingAnchor),
                blurEffectTabBar.bottomAnchor.constraint(equalTo: tabBarMenu.bottomAnchor),
                blurEffectTabBar.topAnchor.constraint(equalTo: tabBarMenu.topAnchor),
                
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
        }
        NSLayoutConstraint.activate([
            collectionVW.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionVW.topAnchor.constraint(equalTo: view.topAnchor, constant: -45),
            collectionVW.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionVW.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            topNavigationBarCollectionView.leadingAnchor.constraint(equalTo: peacockImage.trailingAnchor, constant: 5),
            topNavigationBarCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -5),
            topNavigationBarCollectionView.trailingAnchor.constraint(equalTo: chromecastImage.leadingAnchor, constant: -5),
            topNavigationBarCollectionView.heightAnchor.constraint(equalToConstant: 50),
            
            topNavigationBar.leadingAnchor.constraint(equalTo: peacockImage.trailingAnchor, constant: 5),
            topNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -5),
            topNavigationBar.trailingAnchor.constraint(equalTo: chromecastImage.leadingAnchor, constant: -5),
            topNavigationBar.heightAnchor.constraint(equalToConstant: 50),
            
            headerMenuLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerMenuLabel.topAnchor.constraint(equalTo: view.topAnchor),
            headerMenuLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerMenuLabel.bottomAnchor.constraint(equalTo: peacockImage.bottomAnchor, constant: 10),
            
            blurEffectHeaderMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectHeaderMenu.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectHeaderMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurEffectHeaderMenu.bottomAnchor.constraint(equalTo: peacockImage.bottomAnchor, constant: 10),
            
            peacockImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            peacockImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            peacockImage.widthAnchor.constraint(equalToConstant: 40),
            peacockImage.heightAnchor.constraint(equalToConstant: 40),
            
            chromecastImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            chromecastImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            chromecastImage.widthAnchor.constraint(equalToConstant: 30),
            chromecastImage.heightAnchor.constraint(equalToConstant: 30),
            
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
    }
    
    private func setupCollectioViews() {
        DispatchQueue.main.async {
            if self.isScrollable(collectionView: self.topNavigationBarCollectionView) {
                self.replaceCollectionView()
            }
            else {
                if UIApplication.shared.statusBarOrientation.isLandscape {
                    print("LANDSCAPE")
                    let offset = (self.topNavigationBarCollectionView.frame.width - self.topNavigationBarCollectionView.contentSize.width) / 2
                        self.topNavigationBarCollectionView.contentOffset = CGPoint(
                        x: -offset,
                        y: self.topNavigationBarCollectionView.contentOffset.y
                    )
                }
                self.topNavigationBar.isHidden = true
                self.topNavigationBarCollectionView.isHidden = false
            }
        }
    }
    
    private func isScrollable(collectionView: UICollectionView) -> Bool {
        let contentWidth = collectionView.contentSize.width
        let visibleWidth = collectionView.bounds.size.width
        print("IS SCROLLABLE \(contentWidth > visibleWidth)")
        
        return contentWidth > visibleWidth
    }
    
    private func replaceCollectionView() {
        topNavigationBarCollectionView.isHidden = true
        
        topNavigationBar.isHidden = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        print("CCCCCC")
        super.viewWillTransition(to: size, with: coordinator)
        setupCollectioViews()
    }
    
    //função chamada quando o utilizador clica nas imagens da TabBar
    @objc private func imageTappedTabBar(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }
        selectImageTabBar(imageView: tappedImageView)
    }
    
    //função para filtrar os items pela categoria em cada rail
    func filterCategory(category: Category) -> Void {
        if .home == category || .wwe == category || .olympics == category || .myStuff == category {
            // dont filter
            itemsShown = items
        }
        else{
            var data: [HomeSectionsRailsDto] = []
            let oldItems: [HomeSectionsRailsDto] = items
            oldItems.forEach { section in
                if let a = section.items {
                    let filter = a.filter { $0.classification == category.getCategory() }
                    if !filter.isEmpty {
                        let filteredSection = HomeSectionsRailsDto(type: section.type, items: filter, title: section.title, renderHint: section.renderHint)
                        data.append(filteredSection)
                    }
                }
            }
            itemsShown = data
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
extension HomeSectionsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    //Declarar o numero de cells em cada section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return itemsShown[section].items?.count ?? 0
    }
    
    //Atribuição de valores as celulas das collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if( itemsShown[indexPath.section].renderHint?.template == "HIGHLIGHT" ) {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TileHighlightCollectionViewCell.identifier, for: indexPath) as? TileHighlightCollectionViewCell {
                    let rail = itemsShown[indexPath.section]
                    guard let tile = rail.items?[indexPath.row]
                    else {
                        fatalError()
                    }
                    if UITraitCollection.current.horizontalSizeClass == .regular && UITraitCollection.current.verticalSizeClass == .regular {
                        cell.configureImages(imageTileUrl: tile.images.first(where: { $0.type == typeHighlightedImage || $0.type == "railBackground" })?.url, titleImageURL: tile.images.first(where: { $0.type == "titleLogo" })?.url)
                    } else {
                        cell.configureImages(imageTileUrl: tile.images.first(where: { $0.type == typeHighlightedImage || $0.type == "scene34" })?.url, titleImageURL: tile.images.first(where: { $0.type == "titleLogo" })?.url)
                    }
                    
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
        fatalError()
    }
    
    // Declarar o numero de sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return itemsShown.count
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
        if scrollView == collectionVW {
            let contentOffsetY = scrollView.contentOffset.y
            let maxOffset = view.safeAreaLayoutGuide.layoutFrame.height / 3
            let percentage = min(0.5, contentOffsetY / maxOffset)+0.10
            headerMenuLabel.backgroundColor = UIColor(white: 0, alpha: percentage)
            blurEffectHeaderMenu.alpha = min(maxOffset, contentOffsetY) / maxOffset-0.1
        }
    }
    
}
