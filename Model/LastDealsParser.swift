//
//  LastDealsParser.swift
//  EmployeeParser
//
//  Created by Shareen Ali on 04/07/16.
//  Copyright © 2016 Shareen Ali. All rights reserved.
//

import UIKit

@objc protocol LastDealsParserDelegate : NSObjectProtocol
{
    func didReceivedLastDeals(product product : [TodayProductModel])
    func didReceivedLastDealsWithError(status status : Int)
}

class LastDealsParser: NSObject, AsyncLoaderModelDelegate {
    
    var loader : AsyncLoaderModel?
    weak var delegate : LastDealsParserDelegate?
    var lastDealsArray : [TodayProductModel]?
    
    func getLastDeals()
    {
        loader = AsyncLoaderModel()
        loader!.getDataFromURLString(webURL: AppConstant.Static.BASE_URL + "LastDeals" , dataIndex: -1 )
        loader!.delegate = self
    }
    
    func didReceivedData(data data: NSData!, loader: AsyncLoaderModel!, dataIndex: Int)
    {
        let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
        print("ResponseString of LastDeals \(responseString!)")
        processData(data: data)
        self.loader = nil
    }
    
    func didReceivedErrorLoader(loader loader: AsyncLoaderModel!, dataIndex: Int)
    {
        if delegate != nil
        {
            delegate!.didReceivedLastDealsWithError(status: AppConstant.Static.CONNECTION_ERROR)
        }
        self.loader = nil
    }
    
    func processData(data data : NSData)
    {
        lastDealsArray = []
        do
        {
            let result = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSArray
            
            for i in 0..<result.count
            {
                let lastDealsModel = TodayProductModel()
                let lastDealsDict = result[i] as! NSDictionary
                
                lastDealsModel.androidColor = lastDealsDict.objectForKey("AndroidColor") as! String!
                lastDealsModel.categoryId = lastDealsDict.objectForKey("CategoryId") as! String!
                lastDealsModel.categoryName = lastDealsDict.objectForKey("CategoryName") as! String!
                lastDealsModel.productDescription = lastDealsDict.objectForKey("ProductDescription") as! String!
                lastDealsModel.isMultiple = lastDealsDict.objectForKey("IsMultiple") as! String!
                lastDealsModel.mrp = lastDealsDict.objectForKey("MRP") as! String!
                lastDealsModel.maxQty = lastDealsDict.objectForKey("MaxQty") as! String!
//                lastDealsModel.moreImages = lastDealsDict.objectForKey("MoreImages") as! [String!]!
                lastDealsModel.offerPrice = lastDealsDict.objectForKey("OfferPrice") as! String!
                lastDealsModel.productId = lastDealsDict.objectForKey("ProductId") as! String!
                lastDealsModel.productImage = lastDealsDict.objectForKey("ProductImage") as! String!
                lastDealsModel.productName = lastDealsDict.objectForKey("ProductName") as! String!
                lastDealsModel.productRemark = lastDealsDict.objectForKey("ProductRemark") as! String!
                lastDealsModel.shippingCharge = lastDealsDict.objectForKey("ShippingCharges") as! String!
                lastDealsModel.today = lastDealsDict.objectForKey("Today") as! String!
                lastDealsModel.totalQty = lastDealsDict.objectForKey("TotalQty") as! Double!
                lastDealsModel.iOsColor = lastDealsDict.objectForKey("iOsColor") as! String!
                lastDealsModel.shippingCharge = lastDealsDict.objectForKey("ShippingCharges") as! String!
                
                
                var moreImagesArray = lastDealsDict.objectForKey("ProductMoreImages") as! [NSDictionary]!
                
                lastDealsModel.productMoreImages = []
                for j in 0..<moreImagesArray.count
                {
                    let moreImagesDict = moreImagesArray[j]
                    let productMoreImages = ProductMoreImagesModel()
                    
                    productMoreImages.imageURL = moreImagesDict.objectForKey("ImageURL") as! String!
                    productMoreImages.iOsColor = moreImagesDict.objectForKey("iOsColor") as! String!
                    productMoreImages.androidColor = moreImagesDict.objectForKey("AndroidColor") as! String!
                    
                    lastDealsModel.productMoreImages!.append(productMoreImages)
                }
                
                if delegate != nil
                {
                    delegate!.didReceivedLastDeals(product: lastDealsArray!)
                }
            }
        }
        catch
        {
            if delegate != nil
            {
                delegate!.didReceivedLastDealsWithError(status: AppConstant.Static.PROCESSING_ERROR)
            }
        }
    }
}