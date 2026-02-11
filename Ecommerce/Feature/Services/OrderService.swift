//
//  OrderService.swift
//  Ecommerce
//
struct CreateOrderResponse: Codable {
    let success: Bool
    let data: OrderData
}

struct OrderRequest: Codable {
    let shippingAddress: String
    let paymentMethod: String
}

struct OrderResponse: Codable {
    let success: Bool
    let count: Int
    let data: [OrderData]
}

struct OrderData: Codable {
    let id: Int
    let orderNumber: String
    let totalAmount: String
    let status: String
    let paymentStatus: String
    let paymentMethod: String
    let shippingAddress: String
    let orderItems: [OrderItem]
    let user: UserModel?
    let createdAt: String?
}

struct OrderItem: Codable {
    let id: Int
    let quantity: Int
    let price: String
    let product: Product
}

struct Product: Codable {
    let id: Int
    let name: String
    let images: [String]?
}

class OrderService: OrdersServiceProtocol {

    private let api: ApiClient

    init(api: ApiClient) {
        self.api = api
    }

    func createOrder(
        token: String,
        shippingAddress: String,
        paymentMethod: String
    ) async throws
        -> CreateOrderResponse
    {
        let path = "\(ApiConst.orders)"
        let body = OrderRequest(
            shippingAddress: shippingAddress,
            paymentMethod: paymentMethod
        )
        var endpoint = try Endpoint.post(path, body: body)

        print(endpoint)
        endpoint.headers["Authorization"] = "Bearer \(token)"
        let response: CreateOrderResponse = try await api.send(endpoint)
        print(response)
        return response

    }

    func getOrder(token: String) async throws -> OrderResponse {
        let path = "\(ApiConst.orders)"
        var endpoint = Endpoint.get(path)
        endpoint.headers["Authorization"] = "Bearer \(token)"
        let response: OrderResponse = try await api.send(endpoint)
        return response
    }
}
