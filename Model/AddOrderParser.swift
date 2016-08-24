//
//  AddOrderParser.swift
//  EmployeeParser
//
//  Created by Shareen Ali on 05/07/16.
//  Copyright © 2016 Shareen Ali. All rights reserved.
//
import UIKit

protocol AddOrderParserDelegate : NSObjectProtocol
{
    func didReceivedAddOrderStatus(resultCode resultCode : Int)
}

class AddOrderParser: NSObject, AsyncLoaderModelDelegate
{
    var loader : AsyncLoaderModel?
    weak var delegate : AddOrderParserDelegate?
    
    func addReview(products products : [TodayProductModel]!, totalShippingCharge : Int!, orderTotal : Double!)
    {
        let jsonDictionary = NSMutableDictionary()
        
        jsonDictionary.setValue(orderTotal, forKey: "OrderTotal")
        jsonDictionary.setValue("Order Placed", forKey: "Status")
        jsonDictionary.setValue("", forKey: "StatusId")
        jsonDictionary.setValue(totalShippingCharge, forKey: "TotalShippingCharges")
        jsonDictionary.setValue("", forKey: "TransactionId")
        jsonDictionary.setValue(UIDevice.currentDevice().identifierForVendor!.UUIDString, forKey: "iMEINo")
        jsonDictionary.setValue(1, forKey: "levelID")
        jsonDictionary.setValue(NSUserDefaults.standardUserDefaults().valueForKey("userId") as! Int, forKey: "userId")
        jsonDictionary.setValue(0, forKey: "userTypeId")
        
        var orders : [NSDictionary] = []
        
        for product in products
        {
            let orderDict = NSMutableDictionary()
            
            orderDict.setValue(product.offerPrice, forKey: "Price")
            orderDict.setValue(product.productId, forKey: "ProductId")
            orderDict.setValue(product.productRemark, forKey: "ProductRemark")
            orderDict.setValue(product.totalQty, forKey: "Quantity")
            orderDict.setValue(product.shippingCharge, forKey: "ShippingCharge")
            orderDict.setValue("", forKey: "Size")
            orders.append(orderDict)
        }
        
        jsonDictionary.setValue(orders, forKey: "orderDetails")
        
        var jsonData: NSData?
        do
        {
            jsonData = try NSJSONSerialization.dataWithJSONObject(jsonDictionary, options: NSJSONWritingOptions.PrettyPrinted)
        }
        catch
        {
            jsonData = nil
        }
    
        let jsonDataLenght = "\(jsonData!.length)"
        
        let url = NSURL(string: AppConstant.Static.BASE_URL+"AddVendorRating")
        let request = NSMutableURLRequest(URL: url!)
        request.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue(jsonDataLenght, forHTTPHeaderField: "Content-Length")
        request.HTTPMethod = "POST"
        request.HTTPBody = jsonData
        
        loader = AsyncLoaderModel()
        loader!.getDataFromRequest(request: request, dataIndex: -1)
        loader!.delegate = self
    }
    
    func didReceivedData(data data : NSData!, loader : AsyncLoaderModel!, dataIndex : Int)
    {
        processData(data: data)
        self.loader = nil
    }
    
    func didReceivedErrorLoader(loader loader : AsyncLoaderModel!, dataIndex : Int)
    {
        if delegate != nil
        {
            delegate!.didReceivedAddOrderStatus(resultCode: AppConstant.Static.CONNECTION_ERROR)
        }
        
        self.loader = nil
    }
    
    func processData(data data : NSData)
    {
        var result : NSDictionary!
        
        do
        {
        try result = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            
            //check later.
            
                if delegate != nil
                {
                    delegate!.didReceivedAddOrderStatus(resultCode: AppConstant.Static.PLACE_ORDER_SUCCESS)
                }
        }
        catch
        {
            if delegate != nil
            {
                delegate!.didReceivedAddOrderStatus(resultCode: AppConstant.Static.PROCESSING_ERROR)
            }
        }
    }
}