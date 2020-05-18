//
//  GroupViewController.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/22.
//

import UIKit

import ReactorKit
import ReusableKit
import RxCocoa
import RxSwift
import RxViewController
import SnapKit
import Then

final class GroupViewController: BaseViewController, View {
    
    typealias Reactor = GroupViewReactor
    
    // MARK: Properties
    private struct Metric {
        static let cellHeight: CGFloat = 80.0
        static let leftRightMargin: CGFloat = 11.0
        static let topMargin: CGFloat = 16.0
        
    }
    
    private struct Color {
        static let backgroundColor = UIColor.baseBG
        
    }
    
    private struct Font {
        // static let title = UIFont.systemFont(ofSize: 15.0)
    }
    
    private struct Localized {
        static let title = NSLocalizedString("그룹", comment: "그룹")
    }
    
    // MARK: Views
    let label = UILabel().then {
        $0.text = "Group"
    }
    
    private let addButton = UIBarButtonItem(title: "추가", style: .plain, target: nil, action: nil)
    
    // MARK: - Initializing
    init(reactor: Reactor) {
        defer { self.reactor = reactor }
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Localized.title
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    // MARK: - UI Setup
    override func addViews() {
        super.addViews()
        self.view.addSubview(label)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        // Action
        
        addButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                let groupAddVC = GroupAddViewController(reactor: GroupAddViewReactor())
                groupAddVC.modalPresentationStyle = .overFullScreen
                groupAddVC.view.alpha = 0.9
                self.present(groupAddVC, animated: false, completion: nil)
                
                
            }).disposed(by: self.disposeBag)
        
        // State
        
        // View
    }
    
    
    // MARK: - Route
    
    // MARK: - Private
}
