//
//  PhotoOperationQueue.swift
//  kunSplash
//
//  Created by 이진하 on 2021/08/27.
//

import Foundation

// 사진을 다운받는 operation들을 관리하는 클래스
// 다운받고있는지를 확인하는 Dictionary와, Operation을 처리해주는 OperationQueue로 이루어짐.
class PhotoOperations {
    static let shared = PhotoOperations()
    private init() {}
    
    //메인 이미지 다운을 위한 OperationQueue
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    //검색 이미지 다운을 위한 OperationQueue
    lazy var searchDownloadsInProgress: [IndexPath: Operation] = [:]
    lazy var searchDownloadQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}


