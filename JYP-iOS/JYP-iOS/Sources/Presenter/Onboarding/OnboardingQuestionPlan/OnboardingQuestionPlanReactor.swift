//
//  OnboardingWhenJourneyPlanReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/02.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class OnboardingQuestionPlanReactor: Reactor {
    enum Action {
        case didTapCardViewA
        case didTapCardViewB
        case didTapNextButton
    }
    
    enum Mutation {
        case setStateCardViewA(OnboardingCardViewState)
        case setStateCardViewB(OnboardingCardViewState)
        case setIsActiveNextButton(Bool)
        case setIsPresentOnboardingHowToNewPlaceReactor(Bool)
    }
    
    struct State {
        var stateCardViewA: OnboardingCardViewState = .defualt
        var stateCardViewB: OnboardingCardViewState = .defualt
        var isActiveNextButton: Bool = false
        var isPresentOnboardingHowToNewPlaceReactor: Bool = false
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
                .just(.setStateCardViewA(.active)),
                .just(.setStateCardViewB(.inactive)),
                .just(.setIsActiveNextButton(true))
            ])
        case .didTapCardViewB:
            return .concat([
                .just(.setStateCardViewA(.inactive)),
                .just(.setStateCardViewB(.active)),
                .just(.setIsActiveNextButton(true))
            ])
        case .didTapNextButton:
            let isActiveNextButton = currentState.isActiveNextButton
            return Observable<Mutation>.create { emitter in
                if isActiveNextButton {
                    emitter.onNext(.setIsPresentOnboardingHowToNewPlaceReactor(true))
                }
                return Disposables.create()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setStateCardViewA(let state):
            newState.stateCardViewA = state
        case .setStateCardViewB(let state):
            newState.stateCardViewB = state
        case .setIsPresentOnboardingHowToNewPlaceReactor(let bool):
            newState.isPresentOnboardingHowToNewPlaceReactor = bool
        case .setIsActiveNextButton(let bool):
            newState.isActiveNextButton = bool
        }
        
        return newState
    }
}
