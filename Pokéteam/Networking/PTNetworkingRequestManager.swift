//
//  PTNetworkingRequestManager.swift
//  Pokéteam
//
//  Created by Will Chilcutt on 12/20/18.
//  Copyright © 2018 Laoba Labs. All rights reserved.
//

import UIKit

typealias PTNetworkingRequestManagerProgressBlock<ResponseType : Codable> = (Double, PTNetworkingRequestResponse<ResponseType>) -> ()

class PTNetworkingRequestManager <ResponseType : Codable>
{
    private var requestIds : [String] = []
    
    func performRequests(withURLStrings urlStrings : [String], progressBlock : @escaping PTNetworkingRequestManagerProgressBlock<ResponseType>, andCompletionBlock completionBlock : @escaping ([ResponseType]) -> (Void))
    {
        var requestsArray : [PTNetworkingRequest<ResponseType>] = []
        
        for requestURLString in urlStrings
        {
            let request = PTNetworkingRequest<ResponseType>(withRequestURLString: requestURLString)
            
            self.requestIds.append(request.requestId)
            
            requestsArray.append(request)
        }
        
        let totalRequestCount = requestsArray.count
        
        var finishedRequests = 0
        
        var allResults : [ResponseType] = []
        
        for request in requestsArray
        {
            request.performRequest
            { (response) -> (Void) in
                
                switch response
                {
                    case .success(let result, _):
                        allResults.append(result)
                        break
                    default:
                        break
                }
                
                finishedRequests += 1
                
                progressBlock((Double(finishedRequests) / Double(totalRequestCount)),
                              response)
                
                self.requestIds =  self.requestIds.filter { $0 != request.requestId }
                
                if self.requestIds.isEmpty == true
                {
                    completionBlock(allResults)
                }
            }
        }
    }
}
