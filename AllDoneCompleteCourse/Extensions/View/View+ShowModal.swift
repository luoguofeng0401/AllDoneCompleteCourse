//
//  View+ShowModal.swift
//  AllDoneCompleteCourse
//
//  Created by Guofeng Luo on 2026/8/24.
//

import SwiftUI

struct ModalSupport<ModalContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @ViewBuilder let modalContent: () -> ModalContent
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                Color.black
                    .opacity(0.6)
                    .ignoresSafeArea()
                    .transition(.opacity.animation(.smooth))
                    .onTapGesture {
                        isPresented = false
                    }
                modalContent()
            }
        }
        .animation(.easeOut, value: isPresented)
    }
}

extension View {
    func showModal(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> some View) -> some View {
        modifier(ModalSupport(isPresented: isPresented) {
           content()
        })
    }
    
    func showModal<Item>(item: Binding<Item?>, @ViewBuilder content: @escaping (Item) -> some View) -> some View {
        modifier(ModalSupport(isPresented: item.isNotNil()) {
            if let value = item.wrappedValue {
                content(value)
            }
        })
    }
}

fileprivate struct Preview: View {
    @State private var isPresented: Bool = false
    @State private var item: Int? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Show Modal - isPresented")
                .primaryButton()
                .button(.press) {
                    showModalUsingIsPresented()
                }
            
            Text("Show Modal - item")
                .primaryButton()
                .button(.press) {
                    showModalUsingItem()
                }
            }
        .padding()
        .infinityFrame()
        .background(Color.appTheme.viewBackground)
        .showModal(item: $item) { data in
            PreviewModalContentView()
                .transition(.move(edge: .leading))
        }
        .showModal(isPresented: $isPresented) {
            PreviewModalContentView()
                .transition(.move(edge: .bottom))
        }
    }
    
    private func showModalUsingIsPresented() {
        item = nil
        isPresented = true
    }
    
    private func showModalUsingItem() {
        isPresented = false
        item = Int.random(in: 0...10)
    }
}

fileprivate struct PreviewModalContentView: View {
    var body: some View {
        Text("Modal View")
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundStyle(Color.appTheme.accent)
            .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 2)
            .background(Color.appTheme.viewBackground)
            .cornerRadius(.overall)
    }
}

#Preview {
    Preview()
}
