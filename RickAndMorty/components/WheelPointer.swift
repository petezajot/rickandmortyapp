//
//  WheelPointer.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 16/06/26.
//

import SwiftUI

struct WheelPointer: View {
    var body: some View {
        Triangle()
            .fill(.green)
            .frame(width: 28, height: 28)
            .shadow(color: .green, radius: 8)
            .rotationEffect(.degrees(45))
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(
            to: CGPoint(
                x: rect.midX,
                y: rect.minY
            )
        )
        
        path.addLine(
            to: CGPoint(
                x: rect.maxX,
                y: rect.maxY
            )
        )
        
        path.addLine(
            to: CGPoint(
                x: rect.minX,
                y: rect.maxY
            )
        )
        
        path.closeSubpath()
        return path
    }
}
