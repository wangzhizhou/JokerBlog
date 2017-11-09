//
//  URLSession+Promise.swift
//  LoggerAPI
//
//  Created by JokerAtBaoFeng on 2017/9/13.
//

import Foundation
import MiniPromiseKit

extension URLSession {
    func dataTaskPromise(with url: URL) -> Promise<Data> {
        return Promise{ fulfill, reject in
            let dataTask = URLSession(configuration: .default)
                .dataTask(with: url){
                    data, response, error in
                    if let d = data { fulfill(d)}
                    else { reject(error!) }
            }
            dataTask.resume()
        }
    }
}
