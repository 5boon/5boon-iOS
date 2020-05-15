//
//  BaseTableViewCell.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/20.
//

import UIKit

import RxSwift

class BaseTableViewCell: UITableViewCell {
    
    private(set) var didSetupConstraints = false
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.addViews()
        self.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        logger.verbose("DEINIT: \(type(of: self).description().components(separatedBy: ".").last ?? "")")
    }
    
    override func layoutSubviews() {
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func addViews() {
        // override function
    }
    
    
    func setupConstraints() {
        // override function
    }
}

