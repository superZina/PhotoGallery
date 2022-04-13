//
//  DetailViewController.swift
//  kunSplash
//
//  Created by 이진하 on 2021/08/28.
//

import UIKit

protocol  DetailViewProtocol:AnyObject {
    func backToMainVC(endPosition:IndexPath , pageNum:Int)
    func reloadData()
}

class DetailViewController: UIViewController {

    //MARK: - Properties
    lazy var width:CGFloat = UIScreen.main.bounds.width
    lazy var endPosition:IndexPath = startPosition
    
    weak var delegate:DetailViewProtocol?
    weak var photoDelegate:PhotoCollectionViewProtocol?
    
    @IBOutlet weak var PhotoCollectionView: UICollectionView!
    var startPosition:IndexPath = IndexPath()
    var first:Bool = true
    var keyword:String?
    
    //MARK: - IBAction
    
    @IBAction func dismiss(_ sender: Any) {
        delegate?.backToMainVC(endPosition: endPosition, pageNum: photoDelegate?.pageNum ?? 1)
        self.dismiss(animated: true)
    }
        
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        PhotoCollectionView.delegate = self
        PhotoCollectionView.dataSource = self
    }
}

    //MARK: - UICollectionView extension

extension DetailViewController: UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photoDelegate?.photos.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //detail view 처음 로드했을때
        if first {
            first = false
            print("print startPosition is \(startPosition)")
            PhotoCollectionView.scrollToItem(at: startPosition, at: .left, animated: false)
        }
        
        //마지막 위치에 도달하면 api쏴서 리스트 더 불러옴
        if (photoDelegate?.photos.count ?? 0) - 1 == indexPath.item {
            
            if keyword == nil {
                
                guard !ApiManager.shared.isMainPaginating else{
                    return
                }
                //roading ui
                print("page is \(photoDelegate?.pageNum ?? 1)")
                photoDelegate?.pageNum = (photoDelegate?.pageNum ?? 1) + 1
                //pagination : true
                ApiManager.shared.retriveImgList(page: photoDelegate?.pageNum ?? 1, pagination: true, delegate: self)
                
            }else{
                
                guard !ApiManager.shared.isSearchPaginating else{
                    return
                }
                //roading ui
                photoDelegate?.pageNum = (photoDelegate?.pageNum ?? 1) + 1
                //pagination : true
                ApiManager.shared.getDataSearchResult(page: photoDelegate?.pageNum ?? 1, pagination: true, keyword: keyword ?? "", delegate: self)
                
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? PhotoCell else {return UICollectionViewCell()}

        cell.ImgView.image = photoDelegate?.photos[indexPath.item].image
        photoDelegate?.addOperation(collectionView: collectionView, photo: photoDelegate?.photos[indexPath.item] ?? Photo(urlString: "", width: 0, height: 0), at: indexPath)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio = (photoDelegate?.photos[indexPath.item].height ?? 1) / (photoDelegate?.photos[indexPath.item].width ?? 1)
        return CGSize(width: width, height: width * CGFloat(ratio) )
    }
    
    
    
}

//MARK: - ScrollView Delegate Extension

extension DetailViewController : UIScrollViewDelegate {
    //마지막으로 방문한 이미지 위치를 바꿔줌 ( 이전화면으로 돌아갈때 마지막 위치로 스크롤하기 위함 )
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in PhotoCollectionView.visibleCells {
            endPosition = PhotoCollectionView.indexPath(for: cell) ?? IndexPath()
        }
    }
}

//MARK: - retriveImgList Delegate extension

extension DetailViewController: retriveImgListViewDelegate {
    func didSuccessRetriveImgList(photos: [PhotoProperty]) {

        photos.forEach { photo in
            photoDelegate?.photos.append(Photo(urlString: photo.urls.small , width: photo.width , height: photo.height))
        }
        
        DispatchQueue.main.async {
            self.PhotoCollectionView.reloadData()
        }
            
        delegate?.reloadData()
    }
    
    func failedToRequest(message: String) {
        print(message)
    }
    
}
