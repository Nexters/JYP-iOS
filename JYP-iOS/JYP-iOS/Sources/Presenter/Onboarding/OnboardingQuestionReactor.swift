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
        case updateMyPlannerReactor(MyPlannerReactor?)
    }
    
    struct State {
        var stateCardViewA: OnboardingCardViewState = .defualt
        var stateCardViewB: OnboardingCardViewState = .defualt
        var isActiveNextButton: Bool = false
        var onboardingQuestionReactor: OnboardingQuestionReactor?
        var myPlannerReactor: MyPlannerReactor?
    }
    
    let initialState: State
    let mode: Mode
    
    let provider: ServiceProviderType = ServiceProvider.shared
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
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = service.event.flatMap { (event) -> Observable<Mutation> in
            switch event {
            case let .presentMyPlanner(reactor):
                return .just(.updateMyPlannerReactor(reactor))
            }
        }
        
        return Observable.merge(mutation, eventMutation)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .updateCardViewAState(state):
            newState.stateCardViewA = state
        case let .updateCardViewBState(state):
            newState.stateCardViewB = state
        case let .updateIsActiveNextButton(bool):
            newState.isActiveNextButton = bool
        case let .updateOnboardingQuestionReactor(reactor):
            newState.onboardingQuestionReactor = reactor
        case let .updateMyPlannerReactor(reactor):
            newState.myPlannerReactor = reactor
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
        if currentState.isActiveNextButton == false { return .empty() }
        
        switch mode {
        case .joruney:
            let reactor = OnboardingQuestionReactor(mode: .place)
            
            return .concat([
                .just(.updateOnboardingQuestionReactor(reactor)),
                .just(.updateOnboardingQuestionReactor(nil))
            ])
        case .place:
            let reactor = OnboardingQuestionReactor(mode: .plan)
            
            return .concat([
                .just(.updateOnboardingQuestionReactor(reactor)),
                .just(.updateOnboardingQuestionReactor(nil))
            ])
        case .plan:
            service.createUser()
            
            return .empty()
        }
    }
}
