//
//  SocialLoginViewController.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/14.
//

import UIKit

import Pure
import ReactorKit
import ReusableKit
import RxCocoa
import RxSwift
import RxViewController
import SnapKit
import Then

typealias SocialLoginInfo = (type: SocialLoginTypes, token: String, email: String?)

final class SocialLoginViewController: BaseViewController, View {
    
    typealias Reactor = SocialLoginViewReactor
    
    private struct Metric {
        // static let topPadding: CGFloat = 16.0
    }
    
    private struct Color {
        static let background: UIColor = UIColor.black.alpha(0.9)
    }
    
    private struct Font {
        // static let title = UIFont.systemFont(ofSize: 15.0)
    }
    
    // MARK: Properties
    private let socialLoginInfoSubject = PublishSubject<SocialLoginInfo>()
    var socialLoginInfoObservable: Observable<SocialLoginInfo> {
        return socialLoginInfoSubject.asObservable()
    }
    
    // MARK: Views
    private let kakaoButton = UIButton(type: .system).then {
        $0.setTitle("kakao", for: .normal)
    }
    
    private let googleButton = UIButton(type: .system).then {
        $0.setTitle("google", for: .normal)
    }
    
    private let naverButton = UIButton(type: .system).then {
        $0.setTitle("naver", for: .normal)
    }
    
    private let facebookButton = UIButton(type: .system).then {
        $0.setTitle("facebook", for: .normal)
    }
    
    private let appleButton = UIButton(type: .system).then {
        $0.setTitle("apple", for: .normal)
    }
    
    private let closeButton = UIButton(type: .custom).then {
        $0.setTitle("close", for: .normal)
    }
    
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
        self.view.backgroundColor = Color.background
    }
    
    // MARK: - UI Setup
    override func addViews() {
        super.addViews()
        // self.view.addSubView(<#UIView#>)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        // <#UIView#>.snp.makeConstraints
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        // Action
        
        // State
        
        // View
    }
    
    // MARK: - Route
}
