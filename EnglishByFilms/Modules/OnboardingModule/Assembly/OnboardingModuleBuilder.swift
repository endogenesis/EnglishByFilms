//
//  OnboardingModuleBuilder.swift
//  EnglishByFilms
//
//  Created by Mikalai Tsyhankou on 31/08/2026.
//

enum OnboardingModuleBuilder {
    @MainActor
    static func build(
        userPreferencesStore: UserPreferencesStore,
        onFinish: @escaping () -> Void
    ) -> OnboardingView {
        let viewModel = OnboardingViewModel(
            userPreferencesStore: userPreferencesStore,
            onFinish: onFinish
        )

        return OnboardingView(viewModel: viewModel)
    }
}
