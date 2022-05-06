//
//  LTKTableViewCell.swift
//  LTKProject
//
//  Created by Ben Fitzgearl  on 5/5/22.
//

import UIKit

class LTKTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    private var activityIndicatorView = UIActivityIndicatorView()
    public var associatedLTK: LTK? {
        didSet {
            if let associatedLTK = associatedLTK {
                let manager = APIManager()
                manager.heroImagemageFromLTK(associatedLTK, completion: { [weak self] (image) in
                    DispatchQueue.main.async {
                        self?.mainImageView.image = image
                        self?.setNeedsDisplay()
                    }
                })
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func draw(_ rect: CGRect) {
        if mainImageView.image == nil {
            showActivityView()
        } else {
            removeActivityView()
        }
    }
    
    func removeActivityView() {
        UIView.animate(withDuration: 0.25, animations: {
            self.activityIndicatorView.alpha = 0.0
        }, completion: {_ in
            self.activityIndicatorView.removeFromSuperview()
        })
    }
    
    func showActivityView() {
        if self.contentView.subviews.contains(activityIndicatorView) {
            return
        }
        activityIndicatorView.backgroundColor = .white
        activityIndicatorView.alpha = 1.0
        activityIndicatorView.frame = self.contentView.frame
        activityIndicatorView.style = .large
        activityIndicatorView.startAnimating()
        self.contentView.addSubview(activityIndicatorView)
    }
    
}
