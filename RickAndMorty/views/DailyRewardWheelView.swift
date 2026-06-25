//
//  DailyRewardWheelView.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 16/06/26.
//

import SwiftUI

struct DailyRewardWheelView: View {
    @StateObject private var viewModel: DailyRewardViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: DailyRewardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            SpaceBackground()
            
            VStack(spacing: 24) {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                }
                .padding(.horizontal)
                
                Text("Daily Wheel")
                    .font(.orbitronBold(withSize: 20))
                    .foregroundColor(.green)
                    .shadow(color: .green, radius: 6)
                
                ZStack(alignment: .top) {
                    WheelGraphic(
                        prizes: viewModel.prizes,
                        rotation: viewModel.rotation
                    )
                    .frame(width: 280, height: 280)
                    
                    WheelPointer()
                        .offset(y: -14)
                }
                
                Text(viewModel.message)
                    .font(.orbitronBold(withSize: 16))
                    .foregroundColor(.green)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button{
                    withAnimation(.easeOut(duration: 2)) {
                        viewModel.spin()
                    }
                } label: {
                    Text("Spin")
                        .font(.orbitronBold(withSize: 16))
                        .foregroundColor(viewModel.canSpin ? .green : .gray)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(viewModel.canSpin ? .green : .gray, lineWidth: 2)
                        }
                }
                .disabled(!viewModel.canSpin)
                .padding(.horizontal)
            }
        }
    }
}
