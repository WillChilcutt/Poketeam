//
//  PTNetworkingRequest.swift
//  Pokéteam
//
//  Created by Will Chilcutt on 12/20/18.
//  Copyright © 2018 Laoba Labs. All rights reserved.
//

import UIKit

enum PTNetworkingRequestResponse<ResponseType>
{
    case failure(withError : Error, andRequestId : String)
    case success(withResult : ResponseType, andRequestId : String)
}

typealias PTNetworkingRequestResponseTypeCompletionBlock<ResponseType> = (PTNetworkingRequestResponse<ResponseType>) -> (Void)

class PTNetworkingRequest <ResponseType : Codable>
{
    let requestURLString : String
    
    lazy var requestId : String = { return UUID().uuidString } ()
    
    init(withRequestURLString requestURLString : String)
    {
        self.requestURLString = requestURLString
    }
    
    func performRequest(withCompletionBlock completionBlock : @escaping PTNetworkingRequestResponseTypeCompletionBlock<ResponseType>)
    {
        guard let url = URL(string: self.requestURLString) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlRequest)
        { (data, response, error) in
            
            if let error = error
            {
                completionBlock(.failure(withError:error,
                                         andRequestId:self.requestId))
            }
            else if let data = data
            {
                do
                {
                    let requestResult = try JSONDecoder().decode(ResponseType.self,
                                                                 from: data)
                    
                    completionBlock(.success(withResult:requestResult,
                                             andRequestId:self.requestId))
                }
                catch let error
                {
                    completionBlock(.failure(withError:error,
                                             andRequestId:self.requestId))
                }
            }
        }
        
        task.resume()
    }
}
