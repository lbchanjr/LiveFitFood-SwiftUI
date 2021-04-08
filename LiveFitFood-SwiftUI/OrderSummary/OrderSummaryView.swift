//
//  OrderSummaryView.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-04-04.
//

import SwiftUI

struct OrderSummaryView: View {
    /*static*/ let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    @StateObject var shakeCounter = ShakeCounter(count: 3)
    @ObservedObject var order: Order
    
    @State var gameIsActive = false
    @Binding var isActive: Bool
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Your most recent order")) {
                    HStack {
                        Text("Order No.:")
                            .font(.title3)
                            .fontWeight(.medium)
                        Spacer()
                        Text(String(abs(order.number)))
                    }
                    HStack {
                        Text("Order Date:")
                            .font(.title3)
                            .fontWeight(.medium)
                        Spacer()
                        Text("\(order.datetime ?? Date(), formatter: self.dateFormat)")
                    }
                    HStack {
                        Text("Item Ordered:")
                            .font(.title3)
                            .fontWeight(.medium)
                        Spacer()
                        Text("\(order.item?.name ?? "") Package")
                    }
                    HStack {
                        Text("Total Payment:")
                            .font(.title3)
                            .fontWeight(.medium)
                        Spacer()
                        Text("$\(String(format: "%.2f", order.total))")
                    }
                }
                
                Section(header: Text("Win a coupon")) {
                    Button(action: {gameIsActive.toggle()}) {
                            Text("Start game")
                                .fontWeight(.medium)
                            
                    }
                    .disabled(gameIsActive)
                    .opacity(gameIsActive ? 0.5: 1)
                    
                    if gameIsActive {
                        VStack {
                            Text("Shake phone 3 times to see if you can win coupon discounts")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(Color(.systemPink))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            Text(String(shakeCounter.shakeCountdown))
                                .font(.system(size: 80))
                                .foregroundColor(.accentColor)
                                .multilineTextAlignment(.center)
                            Text("tries left!")
                                .font(.headline)
                                .foregroundColor(Color(.label))
                                .multilineTextAlignment(.center)
                        }
                        .onShake {
                            print("Shake detected! Left = \(shakeCounter.shakeCountdown)")
                            shakeCounter.processShake()
                            if shakeCounter.shakeCountdown == 0 {
                                shakeCounter.resetShakeCountdown()
                                gameIsActive = false
                            }
                        }
                    }
                }

                Section(header: Text("Order History")) {
                    List {
                        NavigationLink(destination: OrderHistoryView()) {
                            Text("View past orders")
                                .fontWeight(.medium)
                        }
                    }
                }
                
            }
            .frame(height: UIScreen.main.bounds.height * 0.7)

            Spacer()
            Button(action: {isActive = false}) {
                Text("Return to Welcome Screen")
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .font(.title3)
            }
            .cornerRadius(10)
            
            Spacer()
        }
        .navigationBarTitle(Text("Order Summary"))
        .navigationBarBackButtonHidden(true)
        
    }
    
    init(/*shakeCounter: StateObject<ShakeCounter>,*/ order: Order, isActive: Binding<Bool>) {
        self.order = order
        self._isActive = isActive

        print("Initializing order summary view")

    }
}

// A view modifier that detects shaking and calls a function of our choosing.
struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

struct OrderSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        OrderSummaryView(order: MockData().getOrder(), isActive: .constant(true))
    }
}
