//
//  EmployeeParser.swift
//  EmployeeParser
//
//  Created by Shareen Ali on 01/07/16.
//  Copyright © 2016 Shareen Ali. All rights reserved.
//

import UIKit

@objc protocol EmployeeParserDelegate : NSObjectProtocol {
    
    func didReceivedEmployee(employee employee : EmployeeModel)
    func didReceivedEmployeeWithError(status status : Int)
}

class EmployeeParser: NSObject,AsyncLoaderModelDelegate
{
    var loader : AsyncLoaderModel?
    weak var delegate : EmployeeParserDelegate?
    
    let ID : Int? = 0

    func getEmployee()
    {
    loader = AsyncLoaderModel()
    loader!.getDataFromURLString(webURL: AppConstant.Static.BASE_URL+"Employee/\(ID)", dataIndex: -1)
    loader!.delegate = self
    }
    
    func didReceivedData(data data : NSData!, loader : AsyncLoaderModel!, dataIndex : Int)
    {
        let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
        print("ResponseString of Employee \(responseString!)")
        processData(data: data)
        self.loader = nil
    }
    
    func didReceivedErrorLoader(loader loader : AsyncLoaderModel!, dataIndex : Int)
    {
        if delegate != nil
        {
        delegate!.didReceivedEmployeeWithError(status: AppConstant.Static.CONNECTION_ERROR)
        }
        self.loader = nil
    }
    
    func processData(data data: NSData)
    {
        do
        {
        let result = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
        let empModel = EmployeeModel()
            empModel.address = result.objectForKey("Address") as! String!
            empModel.address2 = result.objectForKey("Address2") as! String!
            empModel.city = result.objectForKey("City") as! String!
            empModel.email = result.objectForKey("email") as! String!
            empModel.firstName = result.objectForKey("firstName") as! String!
            empModel.imei = result.objectForKey("imei") as! String!
            empModel.lastName = result.objectForKey("lastName") as! String!
            empModel.message = result.objectForKey("message") as! String!
            empModel.mobileNo = result.objectForKey("mobileNo") as! String!
            empModel.osType = result.objectForKey("osType") as! String!
            empModel.state = result.objectForKey("state") as! String!
            empModel.status = result.objectForKey("status") as! String!
            empModel.userId = result.objectForKey("userId") as! String!
            empModel.zipCode = result.objectForKey("zipCode") as! String!
            
            if delegate != nil
            {
                delegate!.didReceivedEmployee(employee: empModel)
            }
        }
        
    catch
        {
        if delegate != nil
            {
                delegate!.didReceivedEmployeeWithError(status: AppConstant.Static.PROCESSING_ERROR)
            }
        }
    }
}