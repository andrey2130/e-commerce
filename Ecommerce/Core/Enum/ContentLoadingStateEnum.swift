//
//  ContentLoadingStateEnum.swift
//  Ecommerce
//
//  Created by Andrii Duda on 29.01.2026.
//


enum Loadable<T> {
    case idle
    case loading
    case loaded(T)
    case empty
    case error(Error)
}
