//
//  NeteaseTarget.swift
//  Listen1
//
//  Created by tramp on 2020/12/31.
//

import Foundation
import Moya
import Alamofire

/// NeteaseTarget
enum NeteaseTarget {
    // 热门推荐列表
    case recommends(_ offset: Int, _ length: Int)
    /// 播放列表
    // case playlist()
}

// MARK: - TargetType
extension NeteaseTarget: TargetType {
    
    /// 服务器地址
    internal var baseURL: URL {
        switch self {
        default: return URL.init(string: "https://music.163.com")!
        }
    }
    
    /// 请求路径
    internal var path: String {
        switch self {
        case .recommends(_, _): return "discover/playlist"
        }
    }
    
    /// 请求方式
    internal var method: Moya.Method {
        switch self {
        case .recommends(_,_): return .get
        }
    }
    
    /// 示例数据
    internal var sampleData: Data {
        return "{}".data(using: .utf8)!
    }
    
    /// 请求任务
    internal var task: Task {
        switch self {
        case .recommends(let offset, let length):
            let offset = offset * length
            return .requestParameters(parameters: ["order": "hot", "cat": "全部", "limit": length, "offset": offset], encoding: URLEncoding.queryString)
        }
    }
    
    /// 请求头信息
    internal var headers: [String : String]? {
        return HTTPHeaders.default.dictionary
    }
    
    
}
