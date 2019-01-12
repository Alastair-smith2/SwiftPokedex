//
//  EndpointType.swift
//  Pokedex
//
//  Created by Alastair Smith on 14/12/2018.
//  Copyright © 2018 Alastair Smith. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
