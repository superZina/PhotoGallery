//
//  ViewController.swift
//  kunSplash
//
//  Created by 이진하 on 2021/08/25.
//

import UIKit

class MainViewController: PhotoCollectionViewController {
    
   
   //MARK: - properties
    
    let imageLodaer = ImageLoader()
    
    //MARK: - IBOutlets
    @IBOutlet weak var PhotoCollectionView: UICollectionView!
    
    //MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setDelegateTask()
    }
    
    ///이동하기 전 detailVIew로 선택한 셀 indexPath 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailVC = segue.destination as? DetailViewController {
            detailVC.delegate = self
            detailVC.photoDelegate = self
            
            guard let cell = sender as? PhotoCell else { return }
                                    
            let indexPath = PhotoCollectionView.indexPath(for: cell)
            
            detailVC.startPosition = indexPath ?? IndexPath()
        }
    }
    
    //MARK: - Helpers
    
    //이미지 받은 이후 collectionview에 뿌려줌
    override func didSuccessRetriveImgList(photos: [PhotoProperty]) {
        
        super.didSuccessRetriveImgList(photos: photos)
        
        DispatchQueue.main.async {
            self.PhotoCollectionView.reloadData()
        }
        
    }
            
    override func setDelegateTask() {
        
         ApiManager.shared.retriveImgList(page: 0, delegate: self)
         PhotoCollectionView.delegate = self
         PhotoCollectionView.dataSource = self
        
    }
}

//MARK: - collectionview extension
extension MainViewController:UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellforAtRow(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        doPagingTask(scrollView: scrollView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItem(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
    }
}

//MARK: - Detail delegate extension
extension MainViewController: DetailViewProtocol {
    
    func reloadData() {
        DispatchQueue.main.async {
            self.PhotoCollectionView.reloadData()
        }
    }
    
    func backToMainVC(endPosition: IndexPath, pageNum: Int) {
        print("endposition is \(endPosition)")
        self.PhotoCollectionView.scrollToItem(at: endPosition, at: .centeredVertically, animated: true)
        self.pageNum = pageNum
    }
    
}
