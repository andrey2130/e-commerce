//
//  HomeView.swift
//  Ecommerce
//
//  Created by Andrii Duda on 27.01.2026.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = ProductViewModel()

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    var body: some View {
        VStack {
            switch viewModel.loadingState {
            case .loading:
                ProgressView()
            case .completed:
                content
            case .empty:
                Text("No data loadded")
            case .error:
                ErrorState {
                    Task {
                        await viewModel.loadProducts()
                    }
                }
            }

        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            Task {
                await viewModel.loadProducts()
            }
        }

    }

    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header
                grid
            }

            .padding(.horizontal, 16)

        }
        .task {
            await viewModel.loadProducts()
        }

    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Discover")
                .font(AppFont.largeTitle)
            Text("Find your prefect items ")
                .font(AppFont.subTitle)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var grid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(viewModel.products) { product in
                ProductCard(product: product)
                    .task {
                        await viewModel.loadMore(currentItem: product)
                    }
            }
            .padding(.top, 16)

        }

    }
    
    

}

#Preview {
    HomeView()
}
