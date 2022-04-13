//
//  Entity.swift
//  kunSplash
//
//  Created by 이진하 on 2021/08/26.
//

import Foundation
import UIKit

protocol  retriveImgListViewDelegate {    
    func didSuccessRetriveImgList(photos:[PhotoProperty])
    func failedToRequest(message: String)
}

struct PhotoProperty : Codable {
    let width : Int
    let height : Int
    let blur_hash : String
    let user:User
    let urls:ImageURL
}
struct User:Codable {
    let username:String
    let name:String
}
struct ImageURL: Codable {
    let raw: String
    let full: String
    let regular:String
    let small:String
    let thumb:String
}

struct SearchPhotoResponse:Codable {
    let results:[PhotoProperty]
}
