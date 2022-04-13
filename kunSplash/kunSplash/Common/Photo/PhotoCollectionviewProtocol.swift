//
//  PhotoCollectionviewProtocol.swift
//  kunSplash
//
//  Created by 이진하 on 2021/08/30.
//

import Foundation
import UIKit


protocol PhotoCollectionViewProtocol :AnyObject, retriveImgListViewDelegate {
    
    var isSearchOperation:Bool { get set }
    
    var pageNum:Int { get set }
    
    var photos:[Photo] { get set }
    
    var width:CGFloat { get set }
    
    func setDelegateTask()
    
    func addOperation(collectionView:UICollectionView, photo:Photo, at indexPath: IndexPath)
    
}

