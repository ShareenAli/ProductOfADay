//
//  TodayProductParser.swift
//  POD
//
//  Created by Shareen Ali on 04/07/16.
//  Copyright © 2016 Shareen Ali. All rights reserved.
//

import UIKit

@objc protocol TodayProductParserDelegate : NSObjectProtocol
{
    func didReceivedProductwithCategory(productWithCategory productWithCategory : [TodayProductModel])
    func didReceivedProductwithCategoryWithError(status status : Int)
}

class TodayProductParser: NSObject,AsyncLoaderModelDelegate
{
    var loader : AsyncLoaderModel?
    weak var delegate : TodayProductParserDelegate?
    var todayProductArray : [TodayProductModel]?
    
    func getProductWithCategory()
    {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        print(year)
        print(month)
        print(day)
        
        loader = AsyncLoaderModel()
        loader!.getDataFromURLString(webURL: AppConstant.Static.BASE_URL+"ProductsWithCategory/\(month)-\(day)-\(year)", dataIndex: -1)
        loader!.delegate = self
    }
    
    func didReceivedData(data data : NSData!, loader : AsyncLoaderModel!, dataIndex : Int)
    {
        let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
        print("ResponseString of ProductsWithCategory \(responseString!)")
        
        processData(data: data)
        self.loader = nil
    }
    
    func didReceivedErrorLoader(loader loader : AsyncLoaderModel!, dataIndex : Int)
    {
        if delegate != nil
        {
            delegate!.didReceivedProductwithCategoryWithError(status: AppConstant.Static.CONNECTION_ERROR)
        }
        
        self.loader = nil
    }
    
    func processData(data data: NSData)
    {
        todayProductArray = []
        do
        {
            let result = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
        
            for i in 0..<result.count
            {
                let todayModel = TodayProductModel()
                let todayDict = result[i] as! NSDictionary
                
                todayModel.androidColor = todayDict.objectForKey("AndroidColor") as! String!
                todayModel.categoryId = todayDict.objectForKey("CategoryId") as! String!
                todayModel.categoryName = todayDict.objectForKey("CategoryName") as! String!
                todayModel.productDescription = todayDict.objectForKey("Description") as! String!
                todayModel.isMultiple = todayDict.objectForKey("IsMultiple") as! String!
                todayModel.mrp = todayDict.objectForKey("MRP") as! String!
                todayModel.maxQty = todayDict.objectForKey("MaxQty") as! String!
                todayModel.moreImages = todayDict.objectForKey("MoreImages") as! [String!]!
                todayModel.offerPrice = todayDict.objectForKey("OfferPrice") as! String!
                todayModel.productId = todayDict.objectForKey("ProductId") as! String!
                todayModel.productImage = todayDict.objectForKey("ProductImage") as! String!
                todayModel.productName = todayDict.objectForKey("ProductName") as! String!
                todayModel.productRemark = todayDict.objectForKey("ProductRemark") as! String!
                todayModel.shippingCharge = todayDict.objectForKey("ShippingCharge") as! String!
                todayModel.termsAndConditions = todayDict.objectForKey("TermsAndConditions") as! String!
                todayModel.today = todayDict.objectForKey("Today") as! String!
                todayModel.totalQty = todayDict.objectForKey("TotalQty") as! Double!
                todayModel.iOsColor = todayDict.objectForKey("iOsColor") as! String!
                
                var moreImagesArray = todayDict.objectForKey("ProductMoreImages") as! [NSDictionary]!
                
                todayModel.productMoreImages = []
                for j in 0..<moreImagesArray.count
                {
                    let moreImagesDict = moreImagesArray[j]
                    let productMoreImages = ProductMoreImagesModel()
                    
                    productMoreImages.imageURL = moreImagesDict.objectForKey("ImageURL") as! String!
                    productMoreImages.iOsColor = moreImagesDict.objectForKey("iOsColor") as! String!
                    productMoreImages.androidColor = moreImagesDict.objectForKey("AndroidColor") as! String!
                    
                    todayModel.productMoreImages!.append(productMoreImages)
                }
                
                todayProductArray!.append(todayModel)
            }
            
            if delegate != nil
            {
                delegate!.didReceivedProductwithCategory(productWithCategory: todayProductArray!)
            }
            
        }
        catch
        {
            if delegate != nil
            {
                delegate!.didReceivedProductwithCategoryWithError(status: AppConstant.Static.PROCESSING_ERROR)
            }
        }
    }
}
