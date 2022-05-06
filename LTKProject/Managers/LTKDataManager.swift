//
//  LTKDataManager.swift
//  PageControl
//
//  Created by Ben Fitzgearl  on 5/5/22.
//

import Foundation

class LTKDataManager {
    
    private(set) var ltks = [LTK]()
    private var profiles = [String: LTKProfile]()
    private var products = [String: LTKProduct]()
    
    private static var sharedLTKDataManager: LTKDataManager = {
        let manager = LTKDataManager()
        return manager
    }()
    
    class func shared() -> LTKDataManager {
        return sharedLTKDataManager
    }
    
    public func loadData(_ completion: @escaping (() -> Void)) {
        let apiManager = APIManager()
        apiManager.loadLTKData({ ltkData in
            for ltk in ltkData.ltks {
                self.ltks.append(ltk)
            }
            for profile in ltkData.profiles {
                self.profiles[profile.id] = profile
            }
            for product in ltkData.products {
                self.products[product.id] = product
            }
            completion()
        })
    }
    
    func getLTKAt(index: UInt) -> LTK? {
        guard ltks.count > index else {
            return nil
        }
        return ltks[Int(index)]
    }
    
    func getProfileWithId(_ identifier: String) -> LTKProfile? {
        return profiles[identifier]
    }
    
    func getAllProductsForLTK(_ ltk: LTK?) -> [LTKProduct] {
        guard let ltk = ltk else {
            return [LTKProduct]()
        }
        var result = [LTKProduct]()
        for productId in ltk.product_ids {
            if let product = products[productId] {
                result.append(product)
            }
        }
        return result
    }
}
