import Foundation
import CloudKit


@objc(cloudKitPlugin) class cloudKitPlugin : CDVPlugin {
    var myCloud:CloudKitHelper?

    @objc(initialize:) public func initialize(command: CDVInvokedUrlCommand) {
        let cloudId = command.arguments[0] as! String
        let recordType = command.arguments[1] as! String
        self.myCloud = CloudKitHelper(cloudId, recordType: recordType )
    }

    @objc(set:) public func set(command: CDVInvokedUrlCommand) {
        let key = command.arguments[0] as! String
        let value = command.arguments[1] as! String

        self.myCloud!.set(key,value: value) {
            (succ,err) in
            let pluginResult = err != nil ?
                CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: err?.localizedDescription ?? "Unknown error")
                : CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Saved item to iCloud")

            self.commandDelegate.send(pluginResult, callbackId:command.callbackId);
        }
    }

    @objc(get:) public func get(command: CDVInvokedUrlCommand) {
        let key = command.arguments[0] as! String

        self.myCloud!.get(key) {
            (succ,err) in
            let pluginResult = err != nil ?
                CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: err?.localizedDescription ?? "Unknown error")
                : CDVPluginResult(status: CDVCommandStatus_OK, messageAs: succ )

            self.commandDelegate.send(pluginResult, callbackId:command.callbackId);
        }
    }

    @objc(delete:) public func delete(command: CDVInvokedUrlCommand) {
        let key = command.arguments[0] as! String

        self.myCloud!.delete(key) {
            err in
            let pluginResult = err != nil ?
                CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: err?.localizedDescription ?? "Unknown error")
                : CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Deleted item from iCloud" )

            self.commandDelegate.send(pluginResult, callbackId:command.callbackId);
        }
    }
}


// On your device (or in the simulator) you should make sure you are logged into iCloud and have iCloud Drive enabled.

class CloudKitHelper {
    var identifier, recordType: String

    init(_ identifier:String, recordType:String ) {
        self.identifier = identifier  // iCloud.com.yourName.ios
        self.recordType = recordType  // keyValueStore
    }

    var cloudDatabase: CKDatabase {
        return CKContainer(identifier: self.identifier ).privateCloudDatabase
    }

    func delete(_ key: String, completion: @escaping (NSError?) -> Void) {

        let recordId = CKRecord.ID(recordName: key)

        cloudDatabase.delete(withRecordID: recordId) { deletedRecordId, error in
            DispatchQueue.main.async {
                completion(error as NSError?)
            }
        }
    }

    func get(_ key: String, completion: @escaping (String?, NSError?) -> Void) {

        let recordId = CKRecord.ID(recordName: key)

        cloudDatabase.fetch(withRecordID: recordId) { record, error in

            DispatchQueue.main.async {
                if( record != nil ) {
                    let value = record!["value"] as? String
                    completion(value, error as NSError?)
                } else {
                    completion(nil, error as NSError?)
                }
            }
        }
    }

    func set(_ key: String, value: String, completion: @escaping (CKRecord?, NSError?) -> Void) {

        let recordId = CKRecord.ID(recordName: key)

        cloudDatabase.fetch(withRecordID: recordId) { updatedRecord, error in

            let record = updatedRecord != nil ?
                            updatedRecord as CKRecord?
                : CKRecord(recordType: self.recordType, recordID: recordId )

            record!.setValue(value, forKey: "value")

            self.cloudDatabase.save(record!) { savedRecord, error in

                if error != nil {
                    print("🛑 Cloud update err",error ?? "Unknow error")
                } else {
                    #if DEBUG
                    print("☁️ Succ inserted/updated record to the cloud, with key:",key)
                    #endif
                }

                DispatchQueue.main.async {
                    completion(savedRecord, error as NSError?)
                }
            }
        }
    }


}
