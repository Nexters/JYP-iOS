//
//  OnboardingQuestionReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/18.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class OnboardingQuestionReactor: Reactor {
    enum Action {
        case didTapCardViewA
        case didTapCardViewB
        case didTapNextButton
    }
    
    enum Mutation {
        case updateCardViewAState(OnboardingCardViewState)
        case updateCardViewBState(OnboardingCardViewState)
        case updateIsActiveNextButton(Bool)
        case updateIsPresentNextViewController(Bool)
    }
    
    struct State {
        var stateCardViewA: OnboardingCardViewState = .defualt
        var stateCardViewB: OnboardingCardViewState = .defualt
        var isActiveNextButton: Bool = false
        var isPresentNextViewController: Bool = false
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    // MARK: - Setup Reactor
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapCardViewA:
            return .concat([
                .just(.updateCardViewAState(.active)),
                .just(.updateCardViewBState(.inactive)),
                .just(.updateIsActiveNextButton(true))
            ])
        case .didTapCardViewB:
            return .concat([
                .just(.updateCardViewAState(.inactive)),
                .just(.updateCardViewBState(.active)),
                .just(.updateIsActiveNextButton(true))
            ])
        case .didTapNextButton:
            if currentState.isActiveNextButton {
                return .just(.updateIsPresentNextViewController(true))
            } else {
                return .empty()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .updateCardViewAState(let state):
            newState.stateCardViewA = state
        case .updateCardViewBState(let state):
            newState.stateCardViewB = state
        case .updateIsActiveNextButton(let bool):
            newState.isActiveNextButton = bool
        case .updateIsPresentNextViewController(let bool):
            newState.isPresentNextViewController = bool
        }
        
        return newState
    }
}
