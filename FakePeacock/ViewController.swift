//
//  ViewController.swift
//  FakePeacock
//
//  Created by rpd196 on 03/07/2024.
//

import UIKit

class ViewController: UIViewController {
    
    private let viewModel = MainViewModelImpl()
    
    // Never update view in background thread
    // Remember weak self on closures
    
    @objc
    func buttonTapped() {
        print("Button tapped!")
        
        viewModel.searchPokemon { pokemonDto in
            guard let firstAbility = pokemonDto.abilities.first
            else {
                return
            }
            
            print("Mistakx", firstAbility.ability.name)
            
            DispatchQueue.main.async {
                self.requestButton.setTitle(firstAbility.ability.name, for: .normal)
            }
        }
    }
                                    
    private var requestButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Request Pokemon", for: .normal)
        button.backgroundColor = .brown
        return button
    }()
    
    private var menuBar: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = .red

        view.addSubview(requestButton)
        requestButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            requestButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            requestButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            requestButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            requestButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }
}
