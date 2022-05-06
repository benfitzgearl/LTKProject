//
//  APIManager.swift
//  PageControl
//
//  Created by Ben Fitzgearl  on 5/5/22.
//

import Foundation
import UIKit

class APIManager {
    
    func loadLTKData(_ completion: @escaping (LTKData) -> Void) {
        let jsonUrlString = "https://api-gateway.rewardstyle.com/api/ltk/v2/ltks/?featured=true&limit=20"
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do {
                let ltkData = try JSONDecoder().decode(LTKData.self, from: data)
                completion(ltkData)
            } catch let error {
                print("Error: \(error)")
            }
        }.resume()
    }
    
    func productImageFromProduct(_ product: LTKProduct, completion: @escaping ((UIImage?) -> Void))  {
        imageFrom(product.image_url, completion: completion)
    }
        
    func heroImagemageFromLTK(_ ltk: LTK, completion: @escaping ((UIImage?) -> Void))  {
        imageFrom(ltk.hero_image, completion: completion)
    }
    
    func profileImageFromProfile(_ profile: LTKProfile, completion: @escaping ((UIImage?) -> Void))  {
        imageFrom(profile.avatar_url, completion: completion)
    }
    
    func imageFrom(_ urlString: String, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let imageData = data else { return }
            
            if let image = UIImage(data: imageData) {
                completion(image)
            }
        }.resume()
    }
}
