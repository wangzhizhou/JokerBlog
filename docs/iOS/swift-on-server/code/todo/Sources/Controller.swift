//
//  Controller.swift
//  LoggerAPI
//
//  Created by JokerAtBaoFeng on 2017/9/13.
//

import Foundation
import Kitura

import SwiftyJSON
import CloudFoundryEnv
import Credentials
import CredentialsFacebook
import MiniPromiseKit

class Controller {
    
    let router: Router
    let port = 8090
    
    let url:URL = URL(string: "http://baidu.com")!
    
    var itemStructs = [Item]()
    let itemStructsLock = DispatchSemaphore(value: 1)
    
    let queue = DispatchQueue(label: "com.todolist.controller", qos: .userInitiated, attributes: .concurrent)
    
    init() {
        
        router = Router()
        
        router.all(middleware: BodyParser())
        
        //添加Facebook验证
        //let credentials = Credentials()
        //let facebookCredentialsPlugin = CredentialsFacebookToken()
        //credentials.register(plugin: facebookCredentialsPlugin)
        //router.all("/v1/*/item", allowPartialMatch: true, middleware: credentials)
        
        
        router.get("/hello"){ request, response, callNextHandler in
            response.status(.OK).send("Hello, World!\n")
            callNextHandler()
        }
        
        router.get("/hello/:name"){ request, response, callNextHandler in
            print(request.parameters["name"] as Any)
            response.status(.OK).send("hello,\(request.parameters["name"] ?? "world")!")
            callNextHandler()
        }
        
        router.get("/help"){ request, response, callNextHandler in
            let helpTest = "Your can get all api in json format text or you can fire a file for the function"
            response.status(.OK).send(helpTest)
            callNextHandler()
        }
        
        /* Test Shell Commond:
         *
         * curl localhost:8000/v1/struct/item
         */
        router.get("/v1/struct/item", handler: handleGetCouchDBItems)
        
        
        /* Test Shell Commond:
         *
         *   curl -H "Content-Type: application/json" -X POST -d '{"title":"Finish book!"}' localhost:8000/v1/struct/item
         Added Item(id: 44E5C5AC-C533-4C70-BBAF-F9AD2ED3E0D3, title: "Finish book!")
         */
        router.post("/v1/struct/item", handler: handleAddCouchDBItem)
    }
    
    func handleGetCouchDBItems(
        request: RouterRequest,
        response: RouterResponse,
        callNextHandler: @escaping () -> Void
        ) throws {
        
        _ = firstly {
            getAllItems()
            }
            .then(on: queue) { itemStructs in
                response.send(json: JSON(itemStructs.map{ $0.json }))
            }
            .catch(on: queue){ error  in
                response.status(.badRequest)
                response.send(error.localizedDescription)
            }
            .always(on:queue){ _ in
                callNextHandler()
        }
    }
    
    func getAllItems() -> Promise<[Item]> {
        return firstly {
            URLSession().dataTaskPromise(with: url)
            }
            .then(on: queue){
                dataResult in
                return try self.dataToItems(data: dataResult)
        }
    }
    
    func dataToItems(data: Data) throws -> Promise<[Item]>
    {
        return Promise { fulfill, reject in
            
            let jsonItems = try JSONSerialization.jsonObject(with: data, options: [])
            let items = JSON(jsonItems)
            
            fulfill([Item]())
        }
    }
    
    func handleAddCouchDBItem(
        request: RouterRequest,
        response: RouterResponse,
        callNextHandler: @escaping () -> Void
        ) throws -> Void {
        
        _ = firstly { () -> Promise<Item> in
            guard case let .json(jsonBody)? = request.body else {
                throw ItemError.malformatJSON
            }
            
            let item = try Item(json:jsonBody)
            return addItem(item: item)
            }
            .then(on: queue) { item in
                response.send("Added \(item.title)")
            }
            .catch(on: queue){ error in
                response.status(.badRequest)
                response.send(error.localizedDescription)
            }
            .always(on: queue) {
                callNextHandler()
        }
    }
    
    func addItem(item: Item) -> Promise<Item> {
        return Promise{
            fulfill, reject in
            let session = URLSession(configuration: .default)
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.httpBody = try JSONSerialization.data(withJSONObject: item.json, options: [])
            let dataTask = session.dataTask(with: request) {
                data, response, error in
                if let error = error { reject(error) }
                fulfill(item)
            }
            dataTask.resume()
            
        }
    }
}



