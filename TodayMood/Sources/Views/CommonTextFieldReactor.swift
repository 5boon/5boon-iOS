//
//  CommonTextFieldReactor.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/17.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class CommonTextFieldReactor: Reactor {
    
    enum Action {
        case clearText
        case setText(String?)
        case setEditing(Bool)
    }
    
    enum Mutation {
        case setText(String?)
        case setEditing(Bool)
    }
    
    struct State {
        var text: String?
        var isSecureTextEntry: Bool = false
        var isEditing: Bool = false
        var clearButtonMode: UITextField.ViewMode = .whileEditing
        var placeholder: String?
        var keyboardType: UIKeyboardType
        var returnKeyType: UIReturnKeyType
    }
    
    let initialState: State
    
    init(isSecureTextEntry: Bool = false,
         clearButtonMode: UITextField.ViewMode = .whileEditing,
         placeholder: String? = nil,
         keyboardType: UIKeyboardType = .default,
         returnKeyType: UIReturnKeyType = .default) {
        initialState = State(text: nil,
                             isSecureTextEntry: isSecureTextEntry,
                             isEditing: false,
                             clearButtonMode: clearButtonMode,
                             placeholder: placeholder,
                             keyboardType: keyboardType,
                             returnKeyType: returnKeyType)
    }
    
    // MARK: Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setText(let text):
            return Observable.just(.setText(text))
            
        case .clearText:
            return Observable.just(.setText(nil))
            
        case .setEditing(let isEditing):
            return Observable.just(.setEditing(isEditing))
        }
    }
    
    // MARK: Reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setText(let text):
            state.text = text
        case .setEditing(let isEditing):
            state.isEditing = isEditing
        }
        return state
    }
}
