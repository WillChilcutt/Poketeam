//
//  PTPokeAPIDataSource.swift
//  Pokéteam
//
//  Created by Will Chilcutt on 12/19/18.
//  Copyright © 2018 Laoba Labs. All rights reserved.
//

import UIKit

private let kPTPokeAPIDataSourceServer = "https://pokeapi.co/api/v2/"

private enum PTPokeAPIDataSourceEndpoints : String
{
    case allPokemon = "pokemon"
}

enum PTPokeAPIDataSourceResponse<ResponseType>
{
    case failure(withError : Error)
    case success(withResult : ResponseType)
}

typealias PTPokeAPIDataSourceResponseTypeCompletionBlock<ResponseType> = (PTPokeAPIDataSourceResponse<ResponseType>) -> (Void)

class PTPokeAPIDataSource : NSObject
{
    func getAllPokemon(withCompletionBlock completionBlock : @escaping PTPokeAPIDataSourceResponseTypeCompletionBlock<[PTPokemon]>)
    {
        let requestURLString = kPTPokeAPIDataSourceServer + PTPokeAPIDataSourceEndpoints.allPokemon.rawValue
        
        self.performRequest(forURLString: requestURLString,
                            withResponseType: PTPokemonResponse.self)
        { (response) -> (Void) in
            
            switch response
            {
                case .failure(let error):
                    print("Error getting pokemon: \(error)")
                    break
                case .success(let response):
                    
                    completionBlock(.success(withResult:response.results))
                    break
            }
        }
    }
    
    private func performRequest<ResponseType : Codable>(forURLString urlString : String, withResponseType responseType : ResponseType.Type, withCompletionBlock completionBlock : @escaping PTPokeAPIDataSourceResponseTypeCompletionBlock<ResponseType>)
    {
        guard let url = URL(string: urlString) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlRequest)
        { (data, response, error) in
            
            if let error = error
            {
                completionBlock(.failure(withError:error))
            }
            else if let data = data
            {
                do
                {
                    let requestResult = try JSONDecoder().decode(responseType, from: data)
                    
                    completionBlock(.success(withResult:requestResult))
                }
                catch let error
                {
                    completionBlock(.failure(withError:error))
                }
            }
            else
            {
//                completionBlock(.failure(withError:LLNetworkManagerError.badReponse))
            }
        }
        
        task.resume()
    }
}
