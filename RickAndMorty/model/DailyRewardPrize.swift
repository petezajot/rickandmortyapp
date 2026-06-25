//
//  DailyRewardPrize.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 16/06/26.
//

import Foundation

struct DailyRewardPrize: Identifiable, Equatable {
    let id: Int
    let points: Int
    
    var title: String {
        points > 0 ? "\(points)" : "X"
    }
}
