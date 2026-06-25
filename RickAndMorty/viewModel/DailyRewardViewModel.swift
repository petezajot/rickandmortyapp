//
//  DailyRewardViewModel.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 16/06/26.
//

import Foundation
import Combine

protocol DailyRewardProtocol: ObservableObject {
    var canSpin: Bool { get set }
    var message: String { get set }
    var rotation: Double { get set }
    
    func refresh()
    func spin()
    
}

@MainActor
final class DailyRewardViewModel: DailyRewardProtocol {
    @Published var canSpin: Bool = false
    @Published var message: String = ""
    @Published var rotation: Double = 0
    
    let prizes: [DailyRewardPrize]
    private let dailyRewardManager: DailyRewardManagerProtocol
    
    init(dailyRewardManager: DailyRewardManagerProtocol) {
        self.dailyRewardManager = dailyRewardManager
        self.prizes = dailyRewardManager.prizes
        refresh()
    }
    
    func refresh() {
        canSpin = dailyRewardManager.canSpinToday()
        
        if canSpin {
            message = "Spin once today!"
        } else {
            message = "You already spun today!"
        }
    }
    
    func spin() {
        guard canSpin else {
            message = "You already spun today!"
            return
        }
        
        let result = dailyRewardManager.spin()
        
        switch result {
        case .won(let prize):
            rotateWheel(to: prize.id)
            message = "You won \(prize.points) points!"
        case .noPrize(let prize):
            rotateWheel(to: prize.id)
            message = "Better luck next time"
        case .alreadySpun:
            message = "You already spun today!"
        }
        canSpin = false
    }
}

extension DailyRewardViewModel { // Implementación interna
    private func rotateWheel(to index: Int) {
        let segmentAngle = 360.0 / Double(prizes.count)
        let fullSpins = 360.0 * 4
        let targetAngle = -Double(index) * segmentAngle
        
        rotation = fullSpins + targetAngle
    }
}
