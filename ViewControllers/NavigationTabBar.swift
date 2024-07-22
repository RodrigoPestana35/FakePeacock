import UIKit

class NavigationTabBar: UITabBarController {
    
    private var label: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.clipsToBounds = true
        l.backgroundColor = UIColor(red: 0.3373, green: 0.3373, blue: 0.3373, alpha: 1.0) 
        l.layer.cornerRadius = 30
        l.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        l.layer.zPosition = 0
        return l
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 747),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
        ])
        
        tabBar.layer.zPosition = 100
        
        configureTabs()
    }
    
    private func configureTabs(){
        let home = HomeSectionsViewController()
        let tv = TvViewController()
        let search = SearchViewController()
        let downloads = DownloadsViewController()

        home.tabBarItem.image = UIImage(systemName: "house")
        tv.tabBarItem.image = UIImage(systemName: "tv")
        search.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        downloads.tabBarItem.image = UIImage(systemName: "square.and.arrow.down")

        let homeNav = UINavigationController(rootViewController: home)
        let tvNav = UINavigationController(rootViewController: tv)
        let searchNav = UINavigationController(rootViewController: search)
        let downloadsNav = UINavigationController(rootViewController: downloads)


        setViewControllers([homeNav, tvNav, searchNav, downloadsNav], animated: true)        
    }
    

}
