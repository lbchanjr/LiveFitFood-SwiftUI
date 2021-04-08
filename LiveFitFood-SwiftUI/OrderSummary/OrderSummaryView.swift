//
//  OrderSummaryView.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-04-04.
//

import SwiftUI

struct OrderSummaryView: View {
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
        
    var orderSummaryViewModel: OrderSummaryViewModel
    @StateObject var shakeCounter = ShakeCounter(count: 3)
    
    @ObservedObject var order: Order
    
    @State var showGameNotAllowedAlert = false
    @State var gameIsActive = false
    @State var showCouponDiscountMessage = false
    @State var couponDiscount: Int?
    
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
                        Text(String(format: "%010u", abs(order.number)))
                    }
                    HStack {
                        Text("Order Date:")
                            .font(.title3)
                            .fontWeight(.medium)
                        Spacer()
                        Text("\(order.datetime ?? Date(), formatter: OrderSummaryView.dateFormat)")
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
                    Button(action: {
                        if orderSummaryViewModel.isShakePhoneGameAllowed() {
                            // Allow user to play the game
                            gameIsActive.toggle()
                        } else {
                            showGameNotAllowedAlert.toggle()
                        }
                    }) {
                        Text("Start game")
                            .fontWeight(.medium)
                    }
                    .alert(isPresented: $showGameNotAllowedAlert, content: {
                        Alert(title: Text("No coupons available"), message: Text("You already won coupons today.\n Try again tomorrow."), dismissButton: .default(Text("Ok")))
                    })
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
                                      
                            // result may contain a nil or the discount that was generated
                            couponDiscount = shakeCounter.processShake(for: orderSummaryViewModel.email)
                            
                            if couponDiscount != nil {
                                showCouponDiscountMessage = true
                            } else {
                                showCouponDiscountMessage = false
                            }
                            
                            
// MARK: Commented out so that game function is disabled until a new order is made.
//                            if shakeCounter.shakeCountdown == 0 {
//                                shakeCounter.resetShakeCountdown()
//                                gameIsActive = false
//                            }
                        }
                        .alert(isPresented: $showCouponDiscountMessage) {
                            if couponDiscount == 0 {
                                return Alert(title: Text("Thanks for playing"), message: Text("Unfortunately, you didn't win any coupon discount"), dismissButton: .default(Text("Ok")))
                            } else {
                                return Alert(title: Text("Congratulations!"), message: Text("You have just received a coupon with \(couponDiscount!)% on your next purchase."), dismissButton: .default(Text("Ok")))
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
    
    init(viewModel: OrderSummaryViewModel, order: Order, isActive: Binding<Bool>) {
        self.orderSummaryViewModel = viewModel
        self.order = order
        self._isActive = isActive

        print("Initializing order summary view")

    }
}

struct OrderSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        OrderSummaryView(viewModel: OrderSummaryViewModel(email: "abcde@gmail.com") ,order: MockData().getOrder(), isActive: .constant(true))
    }
}
