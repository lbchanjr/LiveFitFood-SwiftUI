//
//  OrderHistoryView.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-04-06.
//

import SwiftUI

struct OrderHistoryView: View {
    @ObservedObject var viewModel: OrderHistoryViewModel

    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter
    }()

    var body: some View {
        Form {
            ForEach(viewModel.orders) { order in
                
                Section(header: Text("\(order.datetime ?? Date(), formatter: OrderHistoryView.dateFormat)")) {
                    OrderHistoryItemView(order: order)
                }
                
            }
        }
        .padding(.bottom, 5)
        .navigationBarTitle("Order History (\(viewModel.orders.count > 999 ? "999+": String(viewModel.orders.count)))")
    }
}

struct OrderHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        OrderHistoryView(viewModel: OrderHistoryViewModel(email: "abcde@gmail.com"))
    }
}

struct OrderHistoryItemView: View {
    var order: Order
    var body: some View {
        HStack(alignment: .top) {
            Image(order.item?.photo ?? "nophoto")
                .resizable()
                .frame(width: 100, height: 100)
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading) {
                Text(String(format: "Order number: %010u", abs(order.number)))
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .padding(.top, 5)
                Text("\(order.item?.name ?? "") Package")
                    .font(.title3)
                    .fontWeight(.medium)
                //.padding(.vertical, 10)
                Text(String(format: "Amount paid: $%0.2f", order.total))
                    .padding(.top, 5)
            }
        }
    }
}
