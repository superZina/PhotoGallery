//
//  PhotoCollectionViewController.swift
//  kunSplash
//
//  Created by 이진하 on 2021/09/01.
//

import UIKit

class PhotoCollectionViewController:UIViewController , PhotoCollectionViewProtocol {
                
    //MARK: - Properties
    var isSearchOperation: Bool = false
    
    var pageNum: Int = 1
    
    var photos: [Photo] = []
    
    lazy var width: CGFloat = UIScreen.main.bounds.width
    
    var numberOfCell:Int {
        return photos.count
    }
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Helpers
    
    //operation task func
    func addOperation(collectionView:UICollectionView, photo:Photo, at indexPath: IndexPath) {

        if !isSearchOperation {
            //다운로드 중이라면 operation을 큐에 추가하지 않음
            if PhotoOperations.shared.downloadsInProgress[indexPath] != nil { return }

            let downloader = PhotoLoader(photo: photo)

            //다운로드가 끝났다면 해당 셀을 리로드해주는 과정이 필요함.
            downloader.completionBlock = {
                DispatchQueue.main.async {
                    collectionView.reloadItems(at: [indexPath])
                }
            }

            //다운중임을 표시
            PhotoOperations.shared.downloadsInProgress[indexPath] = downloader

            //OperationQueue에 추가
            PhotoOperations.shared.downloadQueue.addOperation(downloader)
        }else {
            
            if PhotoOperations.shared.searchDownloadsInProgress[indexPath] != nil { return }

            let downloader = PhotoLoader(photo: photo)

            //다운로드가 끝났다면 해당 셀을 리로드해주는 과정이 필요함.
            downloader.completionBlock = {
                DispatchQueue.main.async {
                    collectionView.reloadItems(at: [indexPath])
                }
            }

            //다운중임을 표시
            PhotoOperations.shared.searchDownloadsInProgress[indexPath] = downloader

            //OperationQueue에 추가
            PhotoOperations.shared.searchDownloadQueue.addOperation(downloader)

        }
        
    }
    
    //collection view cell size 리턴하는 함수
    func sizeForItem(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)  -> CGSize {
            
        let ratio = photos[indexPath.item].height / photos[indexPath.item].width

        return CGSize(width: width, height: width * CGFloat(ratio) )
    }
    
    // collection view cellForAtRow
    func cellforAtRow(collectionView: UICollectionView ,indexPath:IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? PhotoCell else {return UICollectionViewCell()}

        cell.ImgView.image = photos[indexPath.item].image
        //이미지 다운받아주기 (operation를 큐에 추가)
        addOperation(collectionView: collectionView, photo: photos[indexPath.item], at: indexPath)

        return cell
    }
    
    //paging task
    func doPagingTask(scrollView: UIScrollView , keyword:String? = nil) {
        let height:CGFloat = scrollView.frame.size.height
        let position:CGFloat = scrollView.contentOffset.y

        if position > ( scrollView.contentSize.height - 100  - height){
            //페이징을 하고 있지 않다면 함수를 종료
            
            //검색일때랑 아닐때 분기처리
            if keyword == nil {
                
                guard !ApiManager.shared.isMainPaginating else{
                    return
                }
                //roading ui
                self.pageNum = self.pageNum + 1
                //pagination : true
                ApiManager.shared.retriveImgList(page: pageNum, pagination: true, delegate: self)
                
            }else{
                
                guard !ApiManager.shared.isSearchPaginating else {
                    return
                }
                
                self.pageNum = self.pageNum + 1
                
                ApiManager.shared.getDataSearchResult(page: pageNum, pagination: true, keyword: keyword ?? "", delegate: self)
                
            }
        }
    }
    
    //서버통신 후, 디코딩된 이미지를 받아 collection view에 뿌려주는 delegate 함수
    func didSuccessRetriveImgList(photos: [PhotoProperty]) {
        photos.forEach { photo in
            self.photos.append(Photo(urlString: photo.urls.small , width: photo.width , height: photo.height))
        }
    }
    
    func failedToRequest(message: String) {
        print(message)
    }
    
    func setDelegateTask() {
        
    }
}
