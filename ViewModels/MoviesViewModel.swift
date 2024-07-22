//
//  MoviesViewModel.swift
//  FakePeacock
//
//  Created by rpd196 on 04/07/2024.
//

import Foundation

class MoviesViewModel{
    
    func requestMovies() async{
        guard
            let url = URL(string: "https://mobile.clients.peacocktv.com/bff/sections/v1?template=sections_v2&segment=all_free_users&node_id=292b2706-d3d3-11e9-9aca-c34618da1bc9")
        else{
            return
        }
        
        let request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("x-skyott-activeterritory", forHTTPHeaderField: "US")
//        request.addValue("x-skyott-device", forHTTPHeaderField: "Mobile")
//        request.addValue("x-skyott-language", forHTTPHeaderField: "en")
//        request.addValue("x-skyott-platform", forHTTPHeaderField: "ANDROID")
//        request.addValue("x-skyott-proposition", forHTTPHeaderField: "NBCUOTT")
//        request.addValue("x-skyott-provider", forHTTPHeaderField: "NBCU")
//        request.addValue("x-skyott-territory", forHTTPHeaderField: "US")
        
        Task{
            do{
                let (data,_) = try await URLSession.shared.data(for:request)
                
                if let assets = try? JSONDecoder().decode([MovieDto].self, from: data){
                    print(assets)
                }
                else{
                    print("Invalid Response")
                }
            }
            catch{
                print("Failed to Send POST Request \(error)")
            }
        }
        
        
    }
}
