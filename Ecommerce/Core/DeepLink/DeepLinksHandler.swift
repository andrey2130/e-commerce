//
//  DeepLinksHandler.swift
//  Ecommerce
//
//  Created by Andrii Duda on 01.02.2026.
//

import Foundation

enum DeepLinks: Equatable {
    case product(id: Int)
    case home
    case favorites

    init?(url: URL) {
        guard url.scheme == "ecommerce" else { return nil }

        let path = url.host ?? ""
        let components = url.pathComponents.filter { $0 != "/" }

        switch path {
        case "product":
            if let idString = components.first,
                let id = Int(idString)
            {
                self = .product(id: id)
            } else {
                return nil
            }
        case "home":
            self = .home
        case "favorites":
            self = .favorites
        default:
            return nil
        }
    }
}

@Observable
class DeepLinkManager {
    var currentDeepLink: DeepLinks?
    
    func handle(_ url: URL) {
        guard let deepLink = DeepLinks(url: url) else {
            print("Invalid deep link: \(url)")
            return
        }
        currentDeepLink = deepLink
    }
    
    func reset() {
        currentDeepLink = nil
    }
}
