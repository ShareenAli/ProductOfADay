//
//  AddUserParser.swift
//  POD
//
//  Created by Shareen Ali on 04/07/16.
//  Copyright © 2016 Shareen Ali. All rights reserved.
//

import UIKit

protocol AddUserParserDelegate : NSObjectProtocol
{
    func didReceivedAddUserResult(resultCode resultCode : Int)
}

class AddUserParser: NSObject,AsyncLoaderModelDelegate
{
    var loader : AsyncLoaderModel?
    
    weak var delegate : AddUserParserDelegate?
    
    func addUserWith(name name : String!, mobileno: String!, emailid : String!)
    {
        let jsonDict = NSMutableDictionary()
        
        jsonDict.setValue(name, forKey: "FirstName")
        jsonDict.setValue(mobileno, forKey: "MobileNo")
        jsonDict.setValue(emailid, forKey: "Email")
        jsonDict.setValue("", forKey: "Address")
        jsonDict.setValue("", forKey: "Address2")
        jsonDict.setValue("", forKey: "City")
        jsonDict.setValue(UIDevice.currentDevice().identifierForVendor!.UUIDString, forKey: "IMEI")
        jsonDict.setValue("", forKey: "LastName")
        jsonDict.setValue("", forKey: "Message")
        jsonDict.setValue("i", forKey: "OsType")
        jsonDict.setValue("", forKey: "State")
        jsonDict.setValue("", forKey: "Status")
        jsonDict.setValue("", forKey: "UserId")
        jsonDict.setValue("", forKey: "ZipCode")
        var jsonData: NSData?
        do
        {
            jsonData = try NSJSONSerialization.dataWithJSONObject(jsonDict, options:NSJSONWritingOptions.PrettyPrinted)
        }
        catch
        {
            jsonData = nil
        }
        let jsonDataLength = "\(jsonData!.length)"
        
        let url = NSURL(string: AppConstant.Static.BASE_URL+"AddUserData")
        let request = NSMutableURLRequest(URL: url!)
        request.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue(jsonDataLength, forHTTPHeaderField: "Content-Length")
        request.HTTPMethod = "POST"
        request.HTTPBody = jsonData
        
        loader = AsyncLoaderModel()
        loader!.getDataFromRequest(request: request, dataIndex: -1)
        loader!.delegate = self
    }
    
    func didReceivedData(data data: NSData!, loader: AsyncLoaderModel!, dataIndex: Int)
    {
        processAddUserData(data: data)
        let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
        print("Login Response: \(string!)")
        
        self.loader = nil
    }
    
    func didReceivedErrorLoader(loader loader: AsyncLoaderModel!, dataIndex: Int)
    {
        if delegate != nil
        {
            delegate!.didReceivedAddUserResult(resultCode: AppConstant.Static.CONNECTION_ERROR)
        }
    }
    
    func processAddUserData(data data : NSData)
    {
        do
        {
            let result = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            NSUserDefaults.standardUserDefaults().setObject(result.objectForKey("Address"), forKey: "Address")
            NSUserDefaults.standardUserDefaults().setObject(result.objectForKey("Address2"), forKey: "Address2")
            NSUserDefaults.standardUserDefaults().setObject(result.objectForKey("City"), forKey: "City")
            NSUserDefaults.standardUserDefaults().setObject(result.objectForKey("Email"), forKey: "Email")
            NSUserDefaults.standardUserDefaults().setObject(result.objectForKey("FirstName"), forKey: "FirstName")
            NSUserDefaults.standardUserDefaults().setObject(result.objectForKey("IMEI"), forKey: "IMEI")
            NSUserDefaults.standardUserDefaults().setObject(result.objectForKey("LastName"), forKey: "LastName")
            NSUserDefaults.standardUserDefaults().setObject(result.objectForKey("Message"), forKey: "Message")
            NSUserDefaults.standardUserDefaults().setObject(result.objectForKey("MobileNo"), forKey: "MobileNo")
            NSUserDefaults.standardUserDefaults().setObject(result.objectForKey("OsType"), forKey: "OsType")
            NSUserDefaults.standardUserDefaults().setObject(result.objectForKey("State"), forKey: "State")
            NSUserDefaults.standardUserDefaults().setObject(result.objectForKey("Status"), forKey: "Status")
            NSUserDefaults.standardUserDefaults().setObject(result.objectForKey("UserId"), forKey: "UserId")
            NSUserDefaults.standardUserDefaults().setObject(result.objectForKey("ZipCode"), forKey: "ZipCode")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            if delegate != nil
            {
                delegate!.didReceivedAddUserResult(resultCode: AppConstant.Static.ADD_USER_SUCCESS)
            }
        }
        catch
        {
            if delegate != nil
            {
                delegate!.didReceivedAddUserResult(resultCode: AppConstant.Static.PROCESSING_ERROR)
            }
        }
    }
}
