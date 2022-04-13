//
//  PhotoLoader.swift
//  kunSplash
//
//  Created by 이진하 on 2021/08/26.
//

import Foundation
import UIKit


/// photo 객체를 통해 사진을 다운받는 operation
class PhotoLoader:Operation {
    let photo:Photo
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    override func main() {
        
        if isCancelled { return }
        
        guard  let url = photo.url else { return }
        guard let photoData = try? Data(contentsOf: url) else { return }
        
        if isCancelled { return }
        
        //데이터를 성공적으로 받아왔다면 해당 사진의 이미지를 띄워줌
        if !photoData.isEmpty {
            let defaultImg:UIImage = UIImage(named: "default") ?? UIImage()
            photo.image = UIImage(data: photoData) ?? defaultImg
            //TODO: 이미지 다운이 끝났다 상태변경이 필요
        }
        
    }
    
}
