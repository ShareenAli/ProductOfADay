//
//  GeneratePaymentHash.swift
//  EmployeeParser
//
//  Created by Shareen Ali on 15/07/16.
//  Copyright © 2016 Shareen Ali. All rights reserved.
//

import UIKit

protocol GeneratePaymentHashParserDelegate : NSObjectProtocol
{
    func didReceivedGeneratePaymentHashResult(resultCode resultCode : Int)
    func didReceivedGeneratePaymentSuccess(paymentHashModel paymentHashModel : GeneratePaymentHashModel)
}

class GeneratePaymentHash: NSObject,AsyncLoaderModelDelegate
{
    var loader : AsyncLoaderModel?
    weak var delegate : GeneratePaymentHashParserDelegate?

    func addPaymentHash(key : String,txnid : String, amount : String,FirstName : String,Email : String, productinfo : String )
    {
    let jsonDict = NSMutableDictionary()
        
    jsonDict.setValue(key, forKey: "key")
    jsonDict.setValue(amount, forKey: "amount")
    jsonDict.setValue("", forKey: "txnid")
    jsonDict.setValue(Email, forKey: "Email")
    jsonDict.setValue(productinfo, forKey: "productinfo")
    jsonDict.setValue(FirstName, forKey: "FirstName")
    jsonDict.setValue("", forKey: "udf1")
    jsonDict.setValue("", forKey: "udf2")
    jsonDict.setValue("", forKey: "udf3")
    jsonDict.setValue("", forKey: "udf4")
    jsonDict.setValue("", forKey: "udf5")
    jsonDict.setValue(NSUserDefaults.standardUserDefaults().valueForKey("UserId"), forKey: "UserId")
        
        var jsonData : NSData?
        do
        {
        jsonData = try NSJSONSerialization.dataWithJSONObject(jsonDict, options: NSJSONWritingOptions.PrettyPrinted)
        }
        catch
        {
            jsonData = nil
        }
        let jsonDataLength = "\(jsonData!.length)"
        
        let url = NSURL(string: AppConstant.Static.BASE_URL+"GeneratePaymentHash")
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
        processGeneratePaymentHash(data: data)
        let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
        print("Login Response: \(string!)")
        self.loader = nil
    }
    
    func didReceivedErrorLoader(loader loader: AsyncLoaderModel!, dataIndex: Int)
    {
        if delegate != nil
        {
            delegate!.didReceivedGeneratePaymentHashResult(resultCode: AppConstant.Static.CONNECTION_ERROR)
        }
    }

    func processGeneratePaymentHash(data data : NSData)
    {
        do
        {
            let result = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            let payModel = GeneratePaymentHashModel()
            let message = result.valueForKey("message") as! String
            if message == "success"
            {
                payModel.Hash = result.valueForKey("Hash") as! String
                payModel.TransactionId = result.valueForKey("TransactionId") as! String
            }
            else
            {
                payModel.Hash = result.valueForKey("Hash") as! String
                payModel.TransactionId = "0"
            }
            if delegate != nil
            {
                delegate!.didReceivedGeneratePaymentSuccess(paymentHashModel: payModel)
            }
        }
        catch
        {
            if delegate != nil
            {
                delegate!.didReceivedGeneratePaymentHashResult(resultCode: AppConstant.Static.PROCESSING_ERROR)
            }
        }
    }
}