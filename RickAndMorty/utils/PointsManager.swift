//
//  PointsManager.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 16/06/26.
//

import Foundation

protocol PointsManagerProtocol {
    func getPoints() -> Int
    func addPoints(_ amount: Int)
    func spendPoints(_ amount: Int) -> Bool
}

final class PointsManager: PointsManagerProtocol {
    private var userDefaultsManager: UserDefaultsManager
    
    init(userDefaultsManager: UserDefaultsManager = .shared) {
        self.userDefaultsManager = userDefaultsManager
    }
    
    func getPoints() -> Int {
        userDefaultsManager.getInt(forKey: .userPoints)
    }
    
    func addPoints(_ amount: Int) {
        let currentPoints = getPoints()
        let newPoints = currentPoints + amount
        
        userDefaultsManager.save(newPoints, forKey: .userPoints)
        
        print("Points added: \(amount)")
        print("Current points: \(newPoints)")
    }
    
    func spendPoints(_ amount: Int) -> Bool {
        let currentPoints = getPoints()
        
        guard currentPoints >= amount else {
            print("Not enough points")
            return false
        }
        
        let newPoints = currentPoints - amount
        userDefaultsManager.save(newPoints, forKey: .userPoints)
        
        print("Points spent: \(amount)")
        print("Current points: \(newPoints)")
        
        return true
    }
}
