//
//  APIManager.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 03/06/26.
//

import Foundation

final class APIManager {
    static let shared = APIManager()// Creamos singleton
    private let baseURL = "https://rickandmortyapi.com/api" // Definimos la base de la URL
    
    func request<T: Decodable>(
        _ endpoint: Endpoint,
        method: HTTPMethod,
        body: Encodable? = nil,
        responseType: T.Type
    ) async throws -> T { // Método genérico
        let theURL = "\(baseURL)\(endpoint.path)" // Definimos la URL de la API completa
        guard let url = URL(string: theURL) else { throw APIRestError.invalidURL }
        var request = URLRequest(url: url) // Creamos el request
        request.httpMethod = method.rawValue // Definimos el método
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // Agregamos los headers requeridos por las API's
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let body, method != .get { // Si es GET, no pasamos parámetros como body
            request.httpBody = try JSONEncoder().encode(body) // En caso contrario, agregamos los parámetros al body del request
        }
        
        let (data, response) = try await URLSession.shared.data(for: request) // Ejecutamos la petición al API
        
        guard let httpResponse = response as? HTTPURLResponse else { throw APIRestError.invalidResponse } // Validamos que haya una respuesta
        
        guard (200...299).contains(httpResponse.statusCode) else { // Sí hay una respuesta, validamos su status para verificar sí es o no un error
            throw APIRestError.statusCode(httpResponse.statusCode) // Sí hay error, retornamos ese error y frenamos la ejecución
        }
        
        do {
            return try JSONDecoder().decode(responseType, from: data) // Sí no es un error, entonces mapeamos la respuesta con el modelo de datos y la devolvemos
        } catch let error as APIRestError {
            throw APIRestError.decoding(error) // Si no es posible mapear, retornamos error
        }
    }
}
