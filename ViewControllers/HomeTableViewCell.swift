import UIKit

class HomeTableViewCell: UITableViewCell {
    
    static let identifier = "HomeCustomCell"
    
//    var homeSections: HomeSectionsDto
    
    private let homeViewModel = HomeSectionsViewModelImp()
    
    private let homeCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        return collection
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(homeCollection)
        NSLayoutConstraint.activate([
            homeCollection.topAnchor.constraint(equalTo: homeCollection.topAnchor),
            homeCollection.bottomAnchor.constraint(equalTo: homeCollection.bottomAnchor),
            homeCollection.leadingAnchor.constraint(equalTo: homeCollection.leadingAnchor),
            homeCollection.trailingAnchor.constraint(equalTo: homeCollection.trailingAnchor)
        ])
        
        homeViewModel.execute { homeSctionsDto in
            print("ALGO : \(String(describing: homeSctionsDto.data.group.rails.first?.items?.first?.images.first?.type))")
//            self.homeSections = homeSctionsDto
        }
        
        self.homeCollection.dataSource = self
        self.homeCollection.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as?
                HomeCollectionViewCell else{
            fatalError("Failed to dequeue")
        }
        return cell
    }
    
    
}
