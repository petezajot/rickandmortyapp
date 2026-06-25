//
//  APIRestError.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 03/06/26.
//

import Foundation

enum APIRestError: Error {
    case invalidURL
    case invalidResponse
    case decoding(Error)
    case network(Error)
    case statusCode(Int)
}
