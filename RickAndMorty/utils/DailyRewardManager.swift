//
//  DailyRewardManager.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 16/06/26.
//

import Foundation

protocol DailyRewardManagerProtocol {
    var prizes: [DailyRewardPrize] { get set }
    
    func canSpinToday() -> Bool
    func spin() -> DailyRewardResult
}

enum DailyRewardResult {
    case won(DailyRewardPrize)
    case noPrize(DailyRewardPrize)
    case alreadySpun
}

final class DailyRewardManager: DailyRewardManagerProtocol {
    private let userDefaultsManager: UserDefaultsManager
    private let pointsManager: PointsManager
    
    var prizes: [DailyRewardPrize] = [
        DailyRewardPrize(id: 0, points: 5),
        DailyRewardPrize(id: 1, points: 0),
        DailyRewardPrize(id: 2, points: 10),
        DailyRewardPrize(id: 3, points: 0),
        DailyRewardPrize(id: 4, points: 15),
        DailyRewardPrize(id: 5, points: 0),
        DailyRewardPrize(id: 6, points: 20),
        DailyRewardPrize(id: 7, points: 0),
        DailyRewardPrize(id: 8, points: 25),
        DailyRewardPrize(id: 9, points: 0)
    ]
    
    init(
        userDefaultsManager: UserDefaultsManager = .shared,
        pointsManager: PointsManager
    ) {
        self.userDefaultsManager = userDefaultsManager
        self.pointsManager = pointsManager
    }
    
    func canSpinToday() -> Bool {
        guard let lastSpinDate = userDefaultsManager.getDate(forKey: .lastRewardDate) else {
            return true
        }
        
        return !Calendar.current.isDateInToday(lastSpinDate)
    }
    
    func spin() -> DailyRewardResult {
        guard canSpinToday() else {
            return .alreadySpun
        }
        
        guard let prize = prizes.randomElement() else {
            return .noPrize(DailyRewardPrize(id: 0, points: 0))
        }
        
        userDefaultsManager.save(Date(), forKey: .lastDailyRewardDate)
        
        if prize.points > 0 {
            pointsManager.addPoints(prize.points)
            return .won(prize)
        } else {
            return .noPrize(prize)
        }
    }
}
