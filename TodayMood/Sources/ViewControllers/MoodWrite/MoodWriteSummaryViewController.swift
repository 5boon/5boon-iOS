//
//  MoodWriteSummaryViewController.swift
//  TodayMoodTests
//
//  Created by Kanz on 2020/04/20.
//

import UIKit

import ReactorKit
import ReusableKit
import RxCocoa
import RxKeyboard
import RxSwift
import RxViewController
import SnapKit
import Then
import UITextView_Placeholder

final class MoodWriteSummaryViewController: BaseViewController, View {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    typealias Reactor = MoodWriteViewReactor
    
    private struct Metric {
        static let backButtonTop: CGFloat = 52.0
        static let backButtonLeft: CGFloat = 36.0
        
        static let gradientHeight: CGFloat = 375.0 / UIScreen.main.bounds.width * 241.0
        static let navButtonTop: CGFloat = 46.0
        static let navButtonHeight: CGFloat = 28.0
        static let doneRight: CGFloat = 28.0
        
        static let dateTop: CGFloat = 116.0
        static let labelLeft: CGFloat = 62.0
        static let feelTop: CGFloat = 16.0
        
        static let feelIconTop: CGFloat = 120.0
        static let feelIconRight: CGFloat = 30.0
        
        static let settingTop: CGFloat = 12.0
        static let settingLeft: CGFloat = 38.0
        
        static let textViewTop: CGFloat = 25.0
        static let textViewLeftRight: CGFloat = 40.0
        static let textViewBottom: CGFloat = 12.0
    }
    
    private struct Color {
        static let buttonEnable: UIColor = UIColor.white
        static let buttonDisable: UIColor = UIColor.white.alpha(0.5)
        static let label: UIColor = UIColor.white
        static let textViewPlaceholder: UIColor = UIColor.textViewPlaceholder
        static let textViewBackground: UIColor = UIColor.baseBG
        static let textView: UIColor = UIColor.title
    }
    
    private struct Font {
        static let button: UIFont = UIFont.systemFont(ofSize: 17.0)
        static let dateLabel: UIFont = UIFont.systemFont(ofSize: 14.0)
        static let feel: UIFont = UIFont.systemFont(ofSize: 20.0)
        static let feelBold: UIFont = UIFont.boldSystemFont(ofSize: 20.0)
        static let textView: UIFont = UIFont.systemFont(ofSize: 16.0)
    }
    
    // MARK: Views
    private let gradientView = TopGradientView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.colors = [UIColor.gradientTop, UIColor.gradientBottom]
    }
    
    let backButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "back_arrow_white"), for: .normal)
    }
    
    private let doneButton = UIButton(type: .system).then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(Color.buttonEnable, for: .normal)
        $0.setTitleColor(Color.buttonDisable, for: .disabled)
        $0.titleLabel?.font = Font.button
    }
    
    private let dateLabel = UILabel().then {
        $0.font = Font.dateLabel
        $0.textColor = Color.label
        $0.text = "2020년 3월 5일"
    }
    
    private let feelLabel = UILabel().then {
        $0.font = Font.feel
        $0.textColor = Color.label
        $0.text = "안녕하세요. 제이님\n오늘의 기분은 어떠세요?"
        $0.numberOfLines = 2
    }
    
    private let feelIconImageView = UIImageView().then {
        $0.image = UIImage(named: MoodStatusTypes.good.iconName)
    }
    
    let publicSettingView = PublicSettingView()
    
    private let summaryTextView = UITextView().then {
        $0.placeholder = "오늘의 간단한 한 줄을 기록해주세요"
        $0.placeholderColor = Color.textViewPlaceholder
        $0.backgroundColor = Color.textViewBackground
        $0.font = Font.textView
        $0.textColor = Color.textView
        $0.textContainerInset = UIEdgeInsets(top: 0,
                                             left: Metric.textViewLeftRight,
                                             bottom: 5.0,
                                             right: Metric.textViewLeftRight)
    }
    
    // MARK: Properties
    let presentMoodWritePublicSettingViewControllerFactory: ((MoodPublicSettingTypes, [PublicGroup])) -> MoodWritePublicSettingViewController
    
    // MARK: - Initializing
    init(reactor: Reactor,
         presentMoodWritePublicSettingViewControllerFactory: @escaping ((MoodPublicSettingTypes, [PublicGroup])) -> MoodWritePublicSettingViewController) {
        defer { self.reactor = reactor }
        self.presentMoodWritePublicSettingViewControllerFactory = presentMoodWritePublicSettingViewControllerFactory
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UI Setup
    override func addViews() {
        super.addViews()
        
        self.view.addSubview(gradientView)
        gradientView.addSubview(backButton)
        gradientView.addSubview(doneButton)
        gradientView.addSubview(dateLabel)
        gradientView.addSubview(feelLabel)
        gradientView.addSubview(feelIconImageView)
        
        self.view.addSubview(publicSettingView)
        self.view.addSubview(summaryTextView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        gradientView.snp.makeConstraints { make in
            make.top.left.right.width.equalToSuperview()
            make.height.equalTo(Metric.gradientHeight)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(Metric.backButtonTop)
            make.left.equalTo(Metric.backButtonLeft)
        }
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(Metric.navButtonTop)
            make.right.equalTo(-Metric.doneRight)
            make.height.equalTo(Metric.navButtonHeight)
        }
        
        feelIconImageView.snp.makeConstraints { make in
            make.right.equalTo(-Metric.feelIconRight)
            make.top.equalTo(Metric.feelIconTop)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(Metric.dateTop)
            make.left.equalTo(Metric.labelLeft)
        }
        
        feelLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(Metric.feelTop)
            make.left.equalTo(Metric.labelLeft)
        }
        
        publicSettingView.snp.makeConstraints { make in
            make.top.equalTo(gradientView.snp.bottom).offset(Metric.settingTop)
            make.left.equalTo(Metric.settingLeft)
        }
        
        summaryTextView.snp.makeConstraints { make in
            make.top.equalTo(publicSettingView.snp.bottom).offset(Metric.textViewTop)
            make.bottom.equalTo(-Metric.textViewBottom)
            make.left.right.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        bindSubReactor(reactor: reactor)
        
        // Action
        backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: self.disposeBag)
        
        doneButton.rx.tap
            .map { Reactor.Action.sendCreateMood }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.enableRequest }
            .distinctUntilChanged()
            .bind(to: doneButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isSendFinished }
            .filterNil()
            .filter { $0 == true }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                // Notification 필요. (메인 화면 갱신 등)
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { ($0.user, $0.selectedStatus) }
            .filter { $0.0 != nil && $0.1 != nil }
            .subscribe(onNext: { [weak self] (arg) in
                guard let self = self,
                    let user = arg.0, let userName = user.userName,
                    let moodStatus = arg.1 else { return }
                // $0.text = "안녕하세요. 제이님\n오늘의 기분은 어떠세요?"
                self.feelLabel.text = "오늘 \(userName)님의\n기분은 \(moodStatus.title)"
            }).disposed(by: self.disposeBag)
        
        // View
        gradientView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.summaryTextView.resignFirstResponder()
            }).disposed(by: self.disposeBag)
        
        publicSettingView.rx.tapped
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.summaryTextView.resignFirstResponder()
                self.presentPublicSetting()
                    .debug()
                    .map { Reactor.Action.selectPublicSetting($0.0, $0.1) }
                    .bind(to: reactor.action)
                    .disposed(by: self.disposeBag)
            }).disposed(by: self.disposeBag)
        
        summaryTextView.rx.text
            .map { Reactor.Action.setSummary($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // Keyboard
        RxKeyboard.instance.willShowVisibleHeight
            .drive(onNext: { [weak self] willShowVisibleHeight in
                guard let self = self else { return }
                self.summaryTextView.snp.removeConstraints()
                self.summaryTextView.snp.makeConstraints { make in
                    make.top.equalTo(self.publicSettingView.snp.bottom).offset(Metric.textViewTop)
                    make.left.right.equalToSuperview()
                    let bottomOffset: CGFloat = (willShowVisibleHeight > 0) ?
                        willShowVisibleHeight : Metric.textViewBottom
                    make.bottom.equalTo(-bottomOffset)
                }
                self.view.layoutIfNeeded()
            }).disposed(by: self.disposeBag)
    }
    
    private func bindSubReactor(reactor: Reactor) {
        publicSettingView.reactor = reactor.publicSettingViewReactor
    }
    
    // MARK: - Route
    private func presentPublicSetting() -> Observable<(MoodPublicSettingTypes, [PublicGroup])> {
        guard let reactor = self.reactor else { return .empty() }
        let publicType = reactor.currentState.publicType
        let selectedGroups = reactor.currentState.selectedGroups
        let controller = self.presentMoodWritePublicSettingViewControllerFactory((publicType, selectedGroups))
        let nav = controller.navigationWrap()
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
        return controller.selectedPubicSettings
    }
}
