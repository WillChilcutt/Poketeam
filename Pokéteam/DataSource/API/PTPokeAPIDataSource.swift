//
//  PTPokeAPIDataSource.swift
//  Pokéteam
//
//  Created by Will Chilcutt on 12/19/18.
//  Copyright © 2018 Laoba Labs. All rights reserved.
//

import UIKit
import Disk

private let kPTPokeAPIDataSourceServer = "https://pokeapi.co/api/v2/"

private enum PTPokeAPIDataSourceEndpoints
{
    case pokemonDetails(withPokemonId : Int)
    
    func rawValue() -> String
    {
        switch self
        {
            case .pokemonDetails(let pokemonId):
                return "pokemon/\(pokemonId)/"
        }
    }
}

private let kPTPokeAPIDataSourceHasCompletedFullDataLoadKey = "kPTPokeAPIDataSourceHasCompletedFullDataLoadKey"


enum PTPokeAPIDataSourceRequestResponse<ResponseType>
{
    case failure(withError : Error)
    case success(withResult : ResponseType)
}

typealias PTPokeAPIDataSourceResponseTypeCompletionBlock<ResponseType> = (PTPokeAPIDataSourceRequestResponse<ResponseType>) -> (Void)


class PTPokeAPIDataSource : NSObject
{
    class func hasCompletedFullDataLoad() -> Bool
    {
        return UserDefaults.standard.bool(forKey: kPTPokeAPIDataSourceHasCompletedFullDataLoadKey)
    }
    
    //MARK: - Pokemon
    
    func getAllPokemon(withProgressBlock progressBlock : @escaping PTNetworkingRequestManagerProgressBlock<[PTPokemon]>, andCompletionBlock completionBlock :() -> (Void))
    {
        var endpoints : [String] = []
        
        var currentPokemonId : Int = 1
        let maxPokemonId : Int = 802
        
        while currentPokemonId <= maxPokemonId
        {
            let endPoint = PTPokeAPIDataSourceEndpoints.pokemonDetails(withPokemonId: currentPokemonId)
            
            endpoints.append(kPTPokeAPIDataSourceServer + endPoint.rawValue())
            
            currentPokemonId += 1
        }
        
        let requestManager = PTNetworkingRequestManager<PTPokemon>()
        
        requestManager.performRequests(withURLStrings: endpoints,
                                       progressBlock:
        { (progress, progressResponse) in
            
            switch progressResponse
            {
                case .success(let pokemon, _):
                    print("Progress: \(progress). Loaded \(pokemon.name)")
                    break
                case .failure(let error, _):
                    print("Progress: \(progress). Error \(error)")
                    break
            }
        })
        { () -> (Void) in
            print("Completed get all pokemon request")
        }
    }
}
