//
//  ImageLoader.swift
//  kunSplash
//
//  Created by 이진하 on 2021/08/26.
//

import Foundation
import UIKit

struct ImageLoader {
    func stringToImageData(url:String) -> UIImage? {
        do {
            let data = try Data(contentsOf: URL(string: url)!)
            return UIImage(data: data) ?? UIImage()
        }catch{
            print(error)
        }
        return nil
    }
}
