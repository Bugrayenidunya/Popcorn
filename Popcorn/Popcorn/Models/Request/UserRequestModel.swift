//
//  UserRequestModel.swift
//  Popcorn
//
//  Created by Enes Buğra Yenidünya on 29.04.2022.
//

import Foundation

final class UserRequestModel: RequestModel {
    
    override init() { }
    
    override var path: String {
        Constant.API.users
    }
    
    override var method: RequestMethod {
        .get
    }
}
