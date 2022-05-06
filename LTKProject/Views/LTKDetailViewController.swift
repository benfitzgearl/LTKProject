//
//  LTKDetailViewController.swift
//  LTKProject
//
//  Created by Ben Fitzgearl  on 5/5/22.
//

import UIKit

class LTKDetailViewController: UIViewController {

    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var profileBarView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    private let associatedLTK: LTK
    private let apiManager = APIManager()
    private var products = [LTKProduct]()
    private let collectionCellId = "cellID"
    
    init(associatedLTK: LTK) {
        self.associatedLTK = associatedLTK
        super.init(nibName: "LTKDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"titlebar_back"), style: .plain, target: self, action: #selector(backButtonTapped(_:)))
        setupUI()
    }
    
    @objc func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupUI() {
        configureProfile()
        configureHeroImage()
        configureProducts()
    }
    
    func configureProducts() {
        products = LTKDataManager.shared().getAllProductsForLTK(associatedLTK)
        productsCollectionView.register(LTKProductCollectionViewCell.self, forCellWithReuseIdentifier: collectionCellId)
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
    }
    
    func configureProfile() {
        guard let profile = LTKDataManager.shared().getProfileWithId(associatedLTK.profile_id) else {
            return
        }
        apiManager.profileImageFromProfile(profile, completion: { (image) in
            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
        })
        profileNameLabel.text = profile.display_name
    }
    
    func configureHeroImage() {
        apiManager.heroImagemageFromLTK(associatedLTK, completion: { (image) in
            DispatchQueue.main.async {
                self.heroImageView.image = image
            }
        })
    }

}

extension LTKDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellId, for: indexPath) as? LTKProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        apiManager.productImageFromProduct(products[indexPath.row], completion: { (image) in
            DispatchQueue.main.async {
                cell.productImage = image
            }
        })
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        if let url = URL(string: product.hyperlink) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

//TODO: Implement in interface builder
class LTKProductCollectionViewCell: UICollectionViewCell {
    
    private var imageView: UIImageView?
    var productImage: UIImage? {
        didSet {
           setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if imageView == nil {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
            self.contentView.addSubview(imageView!)
        }
        imageView?.image = productImage
    }
}
