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

typealias PTPokeAPIDataSourceResponseTypeCompletionBlock<ResponseType> = (PTNetworkingResponse<ResponseType>) -> (Void)

class PTPokeAPIDataSource : NSObject
{
    class func hasCompletedFullDataLoad() -> Bool
    {
        return UserDefaults.standard.bool(forKey: kPTPokeAPIDataSourceHasCompletedFullDataLoadKey)
    }
    
    class func setHasCompletedFullDataLoad()
    {
        UserDefaults.standard.set(true, forKey: kPTPokeAPIDataSourceHasCompletedFullDataLoadKey)
    }
    
    //MARK: - Pokemon
    
    func getAllPokemon(withProgressBlock progressBlock : @escaping PTNetworkingRequestManagerProgressBlock<PTPokemon>, andCompletionBlock completionBlock : @escaping ([PTPokemon]) -> (Void))
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
                                       progressBlock:progressBlock,
                                       andCompletionBlock: completionBlock)
    }
}
