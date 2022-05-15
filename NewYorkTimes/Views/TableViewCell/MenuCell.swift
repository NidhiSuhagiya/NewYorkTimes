//
//  MenuCell.swift
//  NewYorkTimes
//
//  Created by Nidhi Suhagiya on 12/05/22.
//

import UIKit

class MenuCell: UICollectionViewCell {
    
    var titleLbl: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        return lbl
    }()
    
    override var isHighlighted: Bool {
        didSet {
            titleLbl.textColor = isHighlighted ? UIColor.cyan : UIColor.white
        }
    }
    
    override var isSelected: Bool {
        didSet {
            titleLbl.textColor = isSelected ? UIColor.cyan : UIColor.white
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
    
    private func setUpViews() {
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        self.contentView.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
        titleLbl.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15).isActive = true
        titleLbl.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15).isActive = true
    }
}
