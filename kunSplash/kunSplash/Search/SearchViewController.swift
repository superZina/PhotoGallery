//
//  SearchViewController.swift
//  kunSplash
//
//  Created by 이진하 on 2021/08/30.
//

import UIKit

class SearchViewController: PhotoCollectionViewController {

    
    //MARK: -IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var PhotoCollectionView: UICollectionView!
    
    var keyword:String?
    
    //MARK: - LifeCycles
    
    override func viewDidLoad() {
        PhotoCollectionView.automaticallyAdjustsScrollIndicatorInsets = false
        setDelegateTask()
        super.viewDidLoad()
    }

    //이동하기 전 detailVIew로 선택한 셀 indexPath 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailVC = segue.destination as? DetailViewController {
            
            detailVC.delegate = self
            detailVC.photoDelegate = self
            detailVC.keyword = keyword ?? ""
            
            guard let cell = sender as? PhotoCell else { return }
                                    
            let indexPath = PhotoCollectionView.indexPath(for: cell)
            
            detailVC.startPosition = indexPath ?? IndexPath()
        }
    }
    
    //MARK: - Helpers
    
    override func setDelegateTask() {

        isSearchOperation = true
        PhotoCollectionView.delegate = self
        PhotoCollectionView.dataSource = self
        searchBar.delegate = self
    }
    
    override func didSuccessRetriveImgList(photos: [PhotoProperty]) {        
        super.didSuccessRetriveImgList(photos: photos)
        
        DispatchQueue.main.async {
            self.PhotoCollectionView.reloadData()
        }
    }
}


//MARK: -CollectionView Extension

extension SearchViewController :UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return cellforAtRow(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItem(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        doPagingTask(scrollView: scrollView ,keyword: self.keyword ?? "" )
    }

    
}

//MARK: - Detail delegate Extension

extension SearchViewController:DetailViewProtocol {
    
    func reloadData() {
        DispatchQueue.main.async {
            self.PhotoCollectionView.reloadData()
        }
    }
    
    func backToMainVC(endPosition: IndexPath, pageNum: Int) {
        self.PhotoCollectionView.scrollToItem(at: endPosition, at: .centeredVertically, animated: true)
        self.pageNum = pageNum
    }
    
}

//MARK: - Search Delegate Extension

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let keyword = searchBar.text {
            DispatchQueue.main.async {
                self.photos = []
                PhotoOperations.shared.searchDownloadQueue.cancelAllOperations()
                PhotoOperations.shared.searchDownloadsInProgress.removeAll()
                self.PhotoCollectionView.reloadData()
            }
            
            
            ApiManager.shared.getDataSearchResult(page: 0, keyword: keyword, delegate: self)
            self.keyword = keyword
        }
        searchBar.endEditing(true)
    }
    
}
