//
//  RMFonts.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 05/06/26.
//

import SwiftUI

extension Font {
    static func orbitronRegular(withSize size: CGFloat) -> Font {
        .custom("Orbitron-Regular", size: size)
    }
    
    static func orbitronBold(withSize size: CGFloat) -> Font {
        .custom("Orbitron-Bold", size: size)
    }
    
    static func orbitronMedium(withSize size: CGFloat) -> Font {
        .custom("Orbitron-Medium", size: size)
    }
}
