//
//  OnboardingQuestionReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/18.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class OnboardingQuestionReactor: Reactor {
    enum Mode {
        case joruney
        case place
        case plan
    }
    
    enum Action {
        case didTapCardViewA
        case didTapCardViewB
        case didTapNextButton
    }
    
    enum Mutation {
        case updateCardViewAState(OnboardingCardViewState)
        case updateCardViewBState(OnboardingCardViewState)
        case updateIsActiveNextButton(Bool)
        case updateOnboardingQuestionReactor(OnboardingQuestionReactor?)
        case updateIsPresentNextViewController(Bool)
    }
    
    struct State {
        var stateCardViewA: OnboardingCardViewState = .defualt
        var stateCardViewB: OnboardingCardViewState = .defualt
        var isActiveNextButton: Bool = false
        var onboardingQuestionReactor: OnboardingQuestionReactor?
        var isPresentNextViewController: Bool = false
    }
    
    let initialState: State
    let mode: Mode
    let service: OnboardingServiceProtocol = ServiceProvider.shared.onboaringService
    
    init(mode: Mode) {
        self.mode = mode
        self.initialState = State()
    }
    
    // MARK: - Setup Reactor
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapCardViewA:
            return mutateDidTapCardViewA()
        case .didTapCardViewB:
            return mutateDidTapCardViewB()
        case .didTapNextButton:
            return mutateDidTapNextButton()
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
        case let .updateOnboardingQuestionReactor(reactor):
            newState.onboardingQuestionReactor = reactor
        case .updateIsPresentNextViewController(let bool):
            newState.isPresentNextViewController = bool
        }
        
        return newState
    }
    
    private func mutateDidTapCardViewA() -> Observable<Mutation> {
        return .concat([
            .just(.updateCardViewAState(.active)),
            .just(.updateCardViewBState(.inactive)),
            .just(.updateIsActiveNextButton(true))
        ])
    }
    
    private func mutateDidTapCardViewB() -> Observable<Mutation> {
        return .concat([
            .just(.updateCardViewAState(.inactive)),
            .just(.updateCardViewBState(.active)),
            .just(.updateIsActiveNextButton(true))
        ])
    }
    
    private func mutateDidTapNextButton() -> Observable<Mutation> {
        if currentState.isActiveNextButton {
            return .concat([
                .just(.updateIsPresentNextViewController(true)),
                .just(.updateIsPresentNextViewController(false))
            ])
        } else {
            return .empty()
        }
    }
}
