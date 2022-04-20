//
//  ApiManager.swift
//  kunSplash
//
//  Created by 이진하 on 2021/08/26.
//

import Foundation


//API Manager
class ApiManager {
    static let shared = ApiManager()
    private init() {}
    
    var isMainPaginating = false
    
    //이미지리스트 요청, 응답 처리하는 함수
    func retriveImgList(page:Int, pagination:Bool = false, delegate:retriveImgListViewDelegate) {
        if pagination {
            isMainPaginating = true
        }
        
        guard let url = URL(string: "\(baseURL)/photos?client_id=\(AccessKey)&page=\(page)") else {
            print("bad Url")
            return }
        
        let request = URLRequest(url: url)
                
        URLSession.shared.dataTask(with: request) { data, response, error in
            let code = (response as? HTTPURLResponse)?.statusCode ?? 0
            switch code {
            case 200:
                let decoded = self.decodeData(data: data ?? Data())
                delegate.didSuccessRetriveImgList(photos: decoded ?? [])
                break
            case 400,403,404:
                delegate.failedToRequest(message: "Bad Access")
                break
            case 401:
                delegate.failedToRequest(message: "UnAuthorized User , Please confirm user id")
                break
            case 500,503:
                delegate.failedToRequest(message: "Server Error")
                break
            default:
                break
            }
            //paging 종료
            if pagination {
                self.isMainPaginating = false
            }
        }.resume()
    }
    
    var isSearchPaginating = false
    
    //검색 요청 응답 처리 함수
    func getDataSearchResult(page:Int, pagination:Bool = false,keyword: String, delegate:retriveImgListViewDelegate) {
        
        if pagination {
            isSearchPaginating = true
        }
        
        guard let url = URL(string: "\(baseURL)/search/photos?client_id=\(AccessKey)&page=\(page)&query=\(keyword)") else {
            print("bad Url")
            return }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            let code = (response as? HTTPURLResponse)?.statusCode ?? 0
            switch code {
            case 200:
                
                let decoded = self.decodeSearchData(data: data ?? Data())
                delegate.didSuccessRetriveImgList(photos: decoded?.results ?? [])
                break
            case 400,403,404:
                delegate.failedToRequest(message: "Bad Access")
                break
            case 401:
                delegate.failedToRequest(message: "UnAuthorized User , Please confirm user id")
                break
            case 500,503:
                delegate.failedToRequest(message: "Server Error")
                break
            default:
                break
            }
            //paging 종료
            if pagination {
                self.isSearchPaginating = false
            }
        }.resume()
    }
    
    //Data -> Image struct parsing
    func decodeData(data:Data) -> [PhotoProperty]? {
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode([PhotoProperty].self, from: data)
            return decoded
        }catch {
            return nil
        }
    }
    
    func decodeSearchData(data:Data) -> SearchPhotoResponse? {
        let decoder = JSONDecoder()
        do {
            let decoded = try  decoder.decode(SearchPhotoResponse.self, from: data)
            return decoded
        }catch {
            return nil
        }
    }

}

