//
//  OnboardingView.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//

import SwiftUI

struct OnboardingView: View {
    @State private var viewModel = OnboardingViewModel()
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $viewModel.currentTab) {
                onboardingPages
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.3), value: viewModel.currentTab)

            VStack(spacing: 24) {
                pageIndicatorView(
                    count: viewModel.onboardingContent.count,
                    current: viewModel.currentTab
                )

                actionButtonsView(
                    onNext: {
                        viewModel.goNext()
                    },
                    onSkip: {
                        viewModel.goSkip()
                    },
                    isLastPage: viewModel.currentTab == viewModel
                        .onboardingContent.count - 1
                )
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.isFinished) { _, finished in
            if finished {
                coordinator.push(.productList)
            }
        }
    }

    private var onboardingPages: some View {
        ForEach(
            Array(viewModel.onboardingContent.enumerated()),
            id: \.offset
        ) { index, item in
            headerSectionView(for: item)
                .padding(.horizontal, 24)
                .tag(index)
        }
    }

    private func headerSectionView(for item: OnboardingModel) -> some View {
        VStack(spacing: 28) {
            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemGray6))
                    .frame(width: 240, height: 180)

                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
                    .frame(width: 260, height: 280)
                    .overlay {
                        Image(item.image)
                            .resizable()
                            .scaledToFit()
                            .padding(24)
                    }
            }

            Spacer()

            VStack(spacing: 12) {
                Text(item.title)
                    .font(AppFont.title)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                Text(item.description)
                    .font(AppFont.callout)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 8)
            }
            .padding(.bottom, 16)
        }
    }

    private struct pageIndicatorView: View {
        let count: Int
        let current: Int

        var body: some View {
            HStack(spacing: 8) {
                ForEach(0..<count, id: \.self) { index in
                    Capsule()
                        .fill(
                            index == current
                                ? Color.black : Color.gray.opacity(0.3)
                        )
                        .frame(width: index == current ? 28 : 8, height: 8)
                        .animation(.easeInOut(duration: 0.3), value: current)
                }
            }
        }
    }

    private struct actionButtonsView: View {
        let onNext: () -> Void
        let onSkip: () -> Void
        let isLastPage: Bool

        var body: some View {
            VStack(spacing: 16) {
                CustomButton(
                    title: isLastPage ? "Get Started" : "Next",
                    font: AppFont.buttonSmall,
                    backgroundColor: .black,
                    isLoading: false
                ) {
                    onNext()
                }

                if !isLastPage {
                    Button(action: onSkip) {
                        Text("Skip")
                            .font(AppFont.subhead)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
    }
}
