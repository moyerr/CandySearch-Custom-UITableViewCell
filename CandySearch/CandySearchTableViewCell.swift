//
//  CandySearchTableViewCell.swift
//  CandySearch
//
//  Created by Robbie Moyer on 6/5/16.
//  Copyright © 2016 Peartree Developers. All rights reserved.
//

import UIKit

class CandySearchTableViewCell: UITableViewCell {

    @IBOutlet weak var candyNameLabel: UILabel!
    @IBOutlet weak var candyCategoryLabel: UILabel!
    @IBOutlet weak var candyImageView: UIImageView!
    @IBOutlet weak var mainCellView: UIView!
    @IBOutlet weak var shadowView: ShadowView!
    
    func setupCellForCandy(candy: Candy) {
        
        print("setupCellForCandy(\(candy.name))")
        print("Current shadowView width: \(shadowView.bounds.width)\n")
        
        // Round the corners
        self.mainCellView.layer.cornerRadius = 8
        self.mainCellView.layer.masksToBounds = true
        self.shadowView.layer.cornerRadius = 8
        self.shadowView.layer.masksToBounds = false
        
        
        self.candyNameLabel.text = candy.name
        self.candyCategoryLabel.text = candy.category
        self.candyImageView.image = UIImage(named: candy.name)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
            print("didSet shadowView's width to: \(self.bounds.width)\n")
        }
    }
    
    private func setupShadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .AllCorners, cornerRadii: CGSize(width: 8, height: 8)).CGPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.mainScreen().scale
    }
}
