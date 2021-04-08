//
//  CheckoutView.swift
//  LiveFitFood-SwiftUI
//
//  Created by Louise Chan on 2021-04-01.
//

import SwiftUI

enum CouponDiscount: Double {
    case none = 0
    case tenPercent = 0.1
    case fiftyPercent = 0.5
}

struct CheckoutView: View {
    @Binding var isActive: Bool
    //@EnvironmentObject var mealkit: Mealkit
    //@EnvironmentObject var loggedUser: LoggedInUser
    //@Environment(\.presentationMode) var presentationMode: Binding
    
    @StateObject var checkoutViewModel: CheckoutViewModel
    
    @State var tipAmountString = "0.00"
    @State var tipPercent = 0
    //@State var couponValue = CouponDiscount.none
    @State var couponValue = Int64(0)
    @State var selection: Int?
    //@State var proceedPressed = false
    //@State var orderProcessed: OrderData?
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Package Name")/*, footer: Text("SKU Code: \(mealkit.sku ?? "")")
                            .font(.subheadline)
                            .padding(.leading)*/) {
                    HStack {
                        Text(checkoutViewModel.mealkit.name ?? "")
                            .bold()
                            .font(.title)
                        Spacer()
                        Text(String(format: "$%.2f", checkoutViewModel.mealkit.price))
                            .font(.title2)
                    }
                    Text("SKU Code: \(checkoutViewModel.mealkit.sku ?? "")")
                                .font(.subheadline)
                }
                
                Section(header: Text("Billing Details")) {
                    HStack {
                        Text("Subtotal")
                            .font(.title3)
                        Spacer()
                        Text(String(format: "$%.2f", checkoutViewModel.mealkit.price))
                    }
                    HStack {
                        Text("Tax (13% HST)")
                            .font(.title3)
                        Spacer()
                        Text(String(format: "$%.2f", checkoutViewModel.tax))
                    }
                    HStack {
                        Text("Coupon discount")
                            .font(.title3)
                        Spacer()
                        Text(String(format: "\(checkoutViewModel.couponDiscount > 0 ? "-":"")$%.2f", checkoutViewModel.couponDiscount))
                    }
                    HStack {
                        Text("Tip amount")
                            .font(.title3)
                        Spacer()
                        Text("$")
                        //TextField("", text: $tipAmountString)
                        TextField("", text: $tipAmountString, onEditingChanged: {_ in}) {
                            if let tipAmount = Double(tipAmountString) {
                                checkoutViewModel.tipAmount = tipAmount
                            } else {
                                tipAmountString = String(format: "%.2f",
                                checkoutViewModel.updateTipAmount(tipPercentage: Double(tipPercent)/100.0))
                            }
                            
                        }
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: UIScreen.main.bounds.width * 0.20)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    
                }
                
                Section(header: Text("Amount To Pay")) {
                    HStack {
                        Text("Total amount")
                            .font(.title3)
                        Spacer()
                        Text(String(format: "$%.2f", checkoutViewModel.total))
                    }
                }
                
                Section (header: Text("Bill Adjustments")){
                    HStack {
                        Stepper(value: $tipPercent, in: 0...30, step: 5, onEditingChanged: {
                            if !$0 {
                                tipAmountString = String(format: "%.2f",
                                checkoutViewModel.updateTipAmount(tipPercentage: Double(tipPercent)/100.0))
                            }
                        }) {
                            Text("Tip: " + String(tipPercent) + "%")
                        }
                    }
                    
                    //HStack {
                    Picker(selection: $couponValue, label: Text("Selected coupon")) {
                            //Text("None").tag(CouponDiscount.none)
                        Text("None").tag(Int64(0))
                            ForEach(checkoutViewModel.coupons) {coupon in
                                Text("\(String(format: "%010u", abs(coupon.code))) (\(String(format: "%.0f", coupon.discount * 100))%)")
                                    //.tag(CouponDiscount(rawValue: coupon.discount))
                                    .tag(coupon.code)
                            }
                            //Text("10% discount").tag(CouponDiscount.tenPercent)
                    }
                    .pickerStyle(DefaultPickerStyle())
                    .onChange(of: couponValue) {_ in
                        // Decouple in view model?
                        if let coupon = checkoutViewModel.coupons.first(where: {($0 as Coupon).code == couponValue}) {
                            _ = checkoutViewModel.updateCouponDiscountAmount(discount: coupon.discount)
                            
                            // This will later be used to mark coupon as used
                            checkoutViewModel.appliedCoupon = coupon
                            
                        } else {
                            checkoutViewModel.appliedCoupon = nil
                        }
                    }
                    //}
                }
            }
            .navigationBarTitle("Order Review")

            NavigationLink(destination: OrderSummaryView(viewModel: OrderSummaryViewModel(email: checkoutViewModel.email), order: checkoutViewModel.order, isActive: $isActive), tag: 1, selection: $selection) {

                Button(action: {
                    print("Proceed clicked!")
                    checkoutViewModel.processOrder()
                    print("process order called")
                    selection = 1
                }) {
                    Text("Proceed")
                        .frame(width: UIScreen.main.bounds.width * 0.65)
                        .padding(.vertical)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

            }

//            Button(action: {
//                print("Proceed clicked!")
//                orderProcessed = checkoutViewModel.processOrder()
//                proceedPressed.toggle()
//
//            }) {
//                Text("Proceed")
//                    .frame(width: UIScreen.main.bounds.width * 0.65)
//                    .padding(.vertical)
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .fullScreenCover(isPresented: $proceedPressed, content: {
//                OrderSummaryView(shakeCounter: ShakeCounter(count: 3), order: self.orderProcessed!, isActive: $isActive)
//            })

        }
        
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(isActive: .constant(true), checkoutViewModel: CheckoutViewModel(email: "test@gmail.com", mealkit: MockData().getMealkit()))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            //.environmentObject(LoggedInUser(email: "test@gmail.com", phone: "12345", image: UIImage(named: "noimage")))
            //.environmentObject(MockData().getMealkit())
    }
}
