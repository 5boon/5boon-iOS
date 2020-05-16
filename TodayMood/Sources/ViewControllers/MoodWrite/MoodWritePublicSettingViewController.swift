//
//  MoodWritePublicSettingViewController.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/21.
//

import UIKit

import ReactorKit
import ReusableKit
import RxCocoa
import RxSwift
import RxViewController
import SnapKit
import Then

final class MoodWritePublicSettingViewController: BaseViewController, ReactorKit.View {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    typealias Reactor = MoodWritePublicSettingViewReactor
    
    private struct Metric {
        static let titleTop: CGFloat = 16.0
        static let textLeftRight: CGFloat = 27.0
        static let descriptionTop: CGFloat = 3.0
        
        static let viewAloneTop: CGFloat = 15.0
        static let selectLeftRight: CGFloat = 27.0
        static let selectHeight: CGFloat = 48.0
        static let underLineHeight: CGFloat = 1.0
        
        static let selectButtonWidthHeight: CGFloat = 24.0
        static let selectButtonRight: CGFloat = 12.0
        static let selectLabelLeftRight: CGFloat = 8.0
        static let arrowRight: CGFloat = 12.0
    }
    
    private struct Color {
        static let title: UIColor = UIColor.title
        static let description: UIColor = UIColor.title
        static let selectLabel: UIColor = UIColor.title
        static let underLine: UIColor = UIColor.underLine
    }
    
    private struct Font {
        static let title: UIFont = UIFont.boldSystemFont(ofSize: 16.0)
        static let description: UIFont = UIFont.systemFont(ofSize: 16.0)
        static let selectLabel: UIFont = UIFont.systemFont(ofSize: 16.0)
    }
    
    // MARK: Views
    private let closeButton = UIBarButtonItem(title: "닫기", style: .plain, target: nil, action: nil)
    private let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: nil, action: nil)
    
    private let titleLabel = UILabel().then {
        $0.textColor = Color.title
        $0.font = Font.title
        $0.text = "오늘의 기분을 공개 할 범위를 설정하세요"
    }
    
    private let descriptionLabel = UILabel().then {
        $0.textColor = Color.description
        $0.font = Font.description
        $0.text = "범위 변경은 작성 후에도 가능합니다"
    }
    
    private let viewAloneBackView = UIView().then {
        $0.isUserInteractionEnabled = true
    }
    
    private let viewAloneButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "publicsetting_checkbox_default"), for: .normal)
        $0.setImage(UIImage(named: "publicsetting_checkbox_selected"), for: .highlighted)
        $0.setImage(UIImage(named: "publicsetting_checkbox_selected"), for: .selected)
        $0.isUserInteractionEnabled = false
    }
    
    private let viewAloneIconImageView = UIImageView().then {
        $0.image = UIImage(named: "publicsetting_private")
    }
    
    private let viewAloneLabel = UILabel().then {
        $0.font = Font.selectLabel
        $0.textColor = Color.selectLabel
        $0.text = "나만 보기"
    }
    
    private let viewAloneUnderLine = UIView().then {
        $0.backgroundColor = Color.underLine
    }
    
    private let viewGroupBackView = UIView().then {
        $0.isUserInteractionEnabled = true
    }
    
    private let viewGroupButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "publicsetting_checkbox_default"), for: .normal)
        $0.setImage(UIImage(named: "publicsetting_checkbox_selected"), for: .highlighted)
        $0.setImage(UIImage(named: "publicsetting_checkbox_selected"), for: .selected)
        $0.isUserInteractionEnabled = false
    }
    
    private let viewGroupIconImageView = UIImageView().then {
        $0.image = UIImage(named: "publicsetting_group")
    }
    
    private let viewGroupLabel = UILabel().then {
        $0.font = Font.selectLabel
        $0.textColor = Color.selectLabel
        $0.text = "그룹과 함께 보기"
    }
    
    private let viewGroupArrowImageView = UIImageView().then {
        $0.image = UIImage(named: "publicsetting_arrow_right")
    }
    
    private let viewGroupUnderLine = UIView().then {
        $0.backgroundColor = Color.underLine
    }
    
    // MARK: Properties
    private let pushMoodWriteGroupListViewControllerFactory: ([PublicGroup]) -> MoodWriteGroupListViewController
    
    private let selectedTuple: PublishSubject<(MoodPublicSettingTypes, [PublicGroup])> = PublishSubject()
    var selectedPubicSettings: Observable<(MoodPublicSettingTypes, [PublicGroup])> {
        return selectedTuple.asObservable()
    }
    
    // MARK: - Initializing
    init(reactor: Reactor,
         pushMoodWriteGroupListViewControllerFactory: @escaping ([PublicGroup]) -> MoodWriteGroupListViewController) {
        defer { self.reactor = reactor }
        self.pushMoodWriteGroupListViewControllerFactory = pushMoodWriteGroupListViewControllerFactory
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "공개 범위 선택"
        self.navigationItem.leftBarButtonItem = closeButton
        self.navigationItem.rightBarButtonItem = doneButton
        self.view.backgroundColor = .white
    }
    
    // MARK: - UI Setup
    override func addViews() {
        super.addViews()
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(descriptionLabel)
        
        self.view.addSubview(viewAloneBackView)
        self.view.addSubview(viewGroupBackView)
        
        self.view.addSubview(viewAloneUnderLine)
        self.view.addSubview(viewGroupUnderLine)
        
        viewAloneBackView.addSubview(viewAloneButton)
        viewAloneBackView.addSubview(viewAloneIconImageView)
        viewAloneBackView.addSubview(viewAloneLabel)
        
        viewGroupBackView.addSubview(viewGroupButton)
        viewGroupBackView.addSubview(viewGroupIconImageView)
        viewGroupBackView.addSubview(viewGroupLabel)
        viewGroupBackView.addSubview(viewGroupArrowImageView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(Metric.titleTop)
            make.left.equalTo(Metric.textLeftRight)
            make.right.equalTo(-Metric.textLeftRight)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.descriptionTop)
            make.left.equalTo(Metric.textLeftRight)
            make.right.equalTo(-Metric.textLeftRight)
        }
        
        viewAloneBackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Metric.viewAloneTop)
            make.left.equalTo(Metric.selectLeftRight)
            make.right.equalTo(-Metric.selectLeftRight)
            make.height.equalTo(Metric.selectHeight)
        }
        
        viewGroupBackView.snp.makeConstraints { make in
            make.top.equalTo(viewAloneBackView.snp.bottom)
            make.left.equalTo(Metric.selectLeftRight)
            make.right.equalTo(-Metric.selectLeftRight)
            make.height.equalTo(Metric.selectHeight)
        }
        
        viewAloneButton.snp.makeConstraints { make in
            make.width.height.equalTo(Metric.selectButtonWidthHeight)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        viewAloneIconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(viewAloneButton.snp.right).offset(Metric.selectButtonRight)
        }
        
        viewAloneLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(viewAloneIconImageView.snp.right).offset(Metric.selectLabelLeftRight)
            make.right.lessThanOrEqualTo(-Metric.selectLabelLeftRight)
        }
        
        viewAloneUnderLine.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(Metric.underLineHeight)
            make.bottom.equalTo(viewAloneBackView.snp.bottom)
        }
        
        viewGroupButton.snp.makeConstraints { make in
            make.width.height.equalTo(Metric.selectButtonWidthHeight)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        viewGroupIconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(viewAloneButton.snp.right).offset(Metric.selectButtonRight)
        }
        
        viewGroupArrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-Metric.arrowRight)
        }
        
        viewGroupLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(viewAloneIconImageView.snp.right).offset(Metric.selectLabelLeftRight)
            make.right.lessThanOrEqualTo(viewGroupArrowImageView.snp.left).offset(-Metric.selectLabelLeftRight)
        }
        
        viewGroupUnderLine.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(Metric.underLineHeight)
            make.bottom.equalTo(viewGroupBackView.snp.bottom)
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        // Action
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
        
        let aloneTapObservable = viewAloneBackView.rx.tapGesture()
            .when(.recognized)
            .map { _ in MoodPublicSettingTypes.private }
            
         let groupTapObservable = viewGroupBackView.rx.tapGesture()
            .when(.recognized)
            .map { _ in MoodPublicSettingTypes.group }
            
        let publicTypeTapped = Observable.merge(aloneTapObservable, groupTapObservable)
        publicTypeTapped
            .map { Reactor.Action.selectType($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        groupTapObservable
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.pushToGroupList()
                    .subscribe(onNext: { groups in
                        reactor.action.onNext(.selectType(.group))
                        reactor.action.onNext(.setSelectedGroups(groups))
                    }).disposed(by: self.disposeBag)
            }).disposed(by: self.disposeBag)
        
        doneButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let publicType = reactor.currentState.publicType
                let selectedGroups = reactor.currentState.selectedGroups
                self.selectedTuple.onNext((publicType, selectedGroups))
                self.selectedTuple.onCompleted()
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.publicType }
            .subscribe(onNext: { [weak self] type in
                guard let self = self else { return }
                self.viewAloneButton.isSelected = type == .private
                self.viewGroupButton.isSelected = type == .group
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isEnable }
            .bind(to: doneButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - Route
    private func pushToGroupList() -> Observable<[PublicGroup]> {
        guard let reactor = self.reactor else { return .empty() }
        let controller = self.pushMoodWriteGroupListViewControllerFactory(reactor.currentState.selectedGroups)
        self.navigationController?.pushViewController(controller, animated: true)
        return controller.selectedGroups
    }
}
