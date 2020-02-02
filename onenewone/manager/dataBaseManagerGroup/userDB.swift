//
//  userDB.swift
//  onenewone
//
//  Created by namik kaya on 2.02.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import Foundation
import SQLite

class userDB: NSObject {
    private let TAG:String = "userDB: "
    
    private var dbFileURL:URL!
    private var dbName:String = "user.sqlite3"
    
    var db:Connection!
    var path:String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    let tableName = Table("videos")
    let id = Expression<Int64>("id")
    let userName = Expression<String>("userName")
    let userBirthDay = Expression<String>("userBirthDay")
    let userCity = Expression<String>("userCity")
    let userHeight = Expression<String>("userHeight")
    let userWeight = Expression<String>("userWeight")
    let userMaritalStatus = Expression<String>("userMaritalStatus")
    let userMilitaryService = Expression<String>("userMilitaryService")
    let userConviction = Expression<String>("userConviction")
    let userDisabilityStatus = Expression<String>("userDisabilityStatus")
    
    
    override init() {
        super.init()
        createDB()
    }
    
    public func createDB(){
        do {
            if db == nil {
                db = try Connection("\(path)/\(dbName)")
            }
            
            if (db.userVersion == 0) {
                do {
                    try db.run(tableName.create { t in
                        t.column(id, primaryKey: true)
                        t.column(userName)
                        t.column(userBirthDay)
                        t.column(userCity)
                        t.column(userHeight)
                        t.column(userWeight)
                        t.column(userMaritalStatus)
                        t.column(userMilitaryService)
                        t.column(userConviction)
                        t.column(userDisabilityStatus)
                    })
                    db.userVersion = 1
                    print("\(TAG): DB güncelleme yapıldı...")
                } catch (let error){
                    print("\(TAG): new db DB oluşturulamadı: \(error)")
                    db.userVersion = 1
                }
            }
            
        } catch (let error){
            print("\(self.TAG): createDB: \(error)")
        }
        print("\(self.TAG): db: \(db.userVersion)")
    }
    
    /*
    func insertVideo(model:videoModel,
                       onSuccess success: @escaping (Bool?) -> Void,
                       onFailure failure: @escaping (Error?) -> Void) {
        do {
            if db == nil {
                db = try Connection("\(path)/\(dbName)")
            }
            
            let insert = tableName.insert(
                projectId <- model.projectId!,
                createDate <- model.createDate!,
                videoPath <- model.videoPath!,
                thumbPath <- model.thumbPath!,
                cameraStatus <- model.cameraStatus!
            )
            try db.run(insert)
            success(true)
        } catch (let error){
            failure(error)
        }
        
    }
    
    func getProjectsVideos(onSuccess success: @escaping (Bool?, [videoModel]?) -> Void,
                    onFailure failure: @escaping (Error?) -> Void){
        
        var myVideoModels: [videoModel] = []
        
        do {
            if db == nil {
                db = try Connection("\(path)/\(dbName)")
            }
            
            for item in try db.prepare(tableName) {
                let d:videoModel = videoModel(id: item[id],
                                              projectId: item[projectId],
                                              createDate: item[createDate],
                                              videoPath: item[videoPath],
                                              thumbPath: item[thumbPath],
                                              cameraStatus: item[cameraStatus])
                myVideoModels.append(d)
            }
            
            if(myVideoModels.count > 0){
                success(true,myVideoModels)
            }else{
                success(false,myVideoModels)
            }
        } catch (let error){
            failure(error)
        }
    }
    
    func getVideoByProjectId(_projectId:String,
                        onSuccess success: @escaping (Bool?, [videoModel]?) -> Void,
                        onFailure failure: @escaping (Error?) -> Void) {
        
        do {
           if db == nil {
                db = try Connection("\(path)/\(dbName)")
            }
            
            let videoData = tableName.where(projectId==_projectId)
            var myVideoModels:[videoModel] = []
            for item in try db.prepare(videoData) {
                let videoItem = videoModel(id: item[id],
                                          projectId: item[projectId],
                                          createDate: item[createDate],
                                          videoPath: item[videoPath],
                                          thumbPath: item[thumbPath],
                                          cameraStatus: item[cameraStatus])
                myVideoModels.append(videoItem)
            }
            
            if(myVideoModels.count > 0){
                success(true,myVideoModels)
            }else{
                success(false,myVideoModels)
            }
            
        } catch let error {
            failure(error)
        }
    }
    
    // video daha önce kaydedilmiş ise true döner
    func checkVideo(model:videoModel, onCallback callback: @escaping (Bool?) -> Void) {
        do {
           if db == nil {
               db = try Connection("\(path)/\(dbName)")
           }
            
            let videoData = tableName.where(videoPath==model.videoPath!)
             
            var myprojectmodel:[projectModel] = []
            for item in try db.prepare(videoData) {
                myprojectmodel.append(projectModel(id: item[id],
                                                   projectId: item[projectId],
                                                   createDate: item[createDate]))
            }
                
            if (myprojectmodel.count > 0) {
                callback(true)
            }else {
                callback(false)
            }
            
        } catch {
            callback(false)
        }
    }
    
    /// video siler id si ni göndermen yeter
    func deleteVideo(_id:Int64?, onCallback callback: @escaping (Bool?) -> Void) {
        guard let _id = _id else { return }
        let item = tableName.filter(id == _id)
        do {
            if try db.run(item.delete()) > 0 {
                callback(true)
            } else {
               callback(false)
            }
        } catch {
            //print("delete failed: \(error)")
            callback(false)
        }
    }
    
    /// id den video datası döner
    func getVideoData(_id:Int64?, onData data: @escaping (Bool?, videoModel?) -> Void) {
        guard let _id = _id else { return }
        do {
           if db == nil {
               db = try Connection("\(path)/\(dbName)")
           }
            
            let videoData = tableName.where(id==_id)
             
            var myVideoModel:videoModel?
            for item in try db.prepare(videoData) {
                //myprojectmodel.append(projectModel(id: item[id], projectId: item[projectId],createDate: item[createDate]))
                
                myVideoModel = videoModel(id: item[id],
                                          projectId: item[projectId],
                                          createDate: item[createDate],
                                          videoPath: item[videoPath],
                                          thumbPath: item[thumbPath],
                                        cameraStatus: item[cameraStatus])
            }
            
            if (myVideoModel != nil) {
                data(true, myVideoModel)
            }else{
                data(false, nil)
            }
        } catch {
            data(false, nil)
        }
    }*/
}
