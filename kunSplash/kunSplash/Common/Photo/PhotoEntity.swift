//
//  Entity.swift
//  kunSplash
//
//  Created by 이진하 on 2021/08/26.
//

import Foundation
import UIKit

//MARK: Photo Entity
class Photo {
    let width : Int
    let height : Int
    let url:URL?
    var image = UIImage()
    
    init(urlString:String ,width: Int,height: Int ) {
        self.url = URL(string: urlString) ?? nil
        self.width = width
        self.height = height
    }
}

