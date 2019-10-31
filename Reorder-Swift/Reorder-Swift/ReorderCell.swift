//
//  ReorderCell.swift
//  Reorder-Swift
//
//  Created by Neebal Tech on 30/10/19.
//  Copyright © 2019 Neebal Technologies. All rights reserved.
//

import UIKit

class ReorderCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.holderView);
        self.holderView.addSubview(self.itemLabel)
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|[holderView]|",
                                                        options: [],
                                                        metrics: nil,
                                                        views: ["holderView":holderView]);
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[holderView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["holderView":holderView]);
        self.contentView.addConstraints(horizontal);
        self.contentView.addConstraints(vertical);
        
        self.itemLabel.centerXAnchor.constraint(equalTo: self.holderView.centerXAnchor).isActive = true
        self.itemLabel.centerYAnchor.constraint(equalTo: self.holderView.centerYAnchor).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var holderView: UIView = {
        let view = UIView();
        view.layer.cornerRadius = 10.0;
        view.translatesAutoresizingMaskIntoConstraints = false;
        // shadow
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 4.0
        view.backgroundColor = .lightGray
        return view;
    }();
    
    let itemLabel: UILabel = {
        
        let label = UILabel();
        label.adjustsFontSizeToFitWidth = true;
        label.font =  UIFont(name: "HelveticaNeue-Medium", size: 18.0);
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textAlignment = .left;
        label.text = "xxx"
        label.textColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1);
        return label;
    }()
}
