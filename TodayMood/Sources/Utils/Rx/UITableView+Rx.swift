//
//  UITableView+Rx.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/20.
//

import RxCocoa
import RxDataSources
import RxSwift

extension Reactive where Base: UITableView {
    func itemSelected<S>(dataSource: TableViewSectionedDataSource<S>) -> ControlEvent<S.Item> {
        let source = self.itemSelected.map { indexPath in
            dataSource[indexPath]
        }
        return ControlEvent(events: source)
    }
}
