//
//  ContentLoadingStateEnum.swift
//  Ecommerce
//
//  Created by Andrii Duda on 29.01.2026.
//


enum ContentLoadingState {
    case loading
    case completed
    case empty
    case error(Error)
}
