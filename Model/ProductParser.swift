//
//  ProductParser.swift
//  EmployeeParser
//
//  Created by Shareen Ali on 01/07/16.
//  Copyright © 2016 Shareen Ali. All rights reserved.
// 

import UIKit

@objc protocol ProductParserDelegate : NSObjectProtocol
{
    func didReceivedProduct(product product : TodayProductModel)
    func didReceivedProductWithError(status status : Int)
}

class ProductParser: NSObject, AsyncLoaderModelDelegate
{
    var loader : AsyncLoaderModel?
    weak var delegate : ProductParserDelegate?
    
    let ID : Int? = 6072
    
    func getProduct()
    {
        loader = AsyncLoaderModel()
        loader!.getDataFromURLString(webURL: AppConstant.Static.BASE_URL + "Product/\(ID)" , dataIndex: -1 )
        loader!.delegate = self
    }
    
    func didReceivedData(data data: NSData!, loader: AsyncLoaderModel!, dataIndex: Int)
    {
        let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
        print("ResponseString of Products \(responseString!)")
        processData(data: data)
        self.loader = nil
    }
    
    func didReceivedErrorLoader(loader loader: AsyncLoaderModel!, dataIndex: Int) {
        if delegate != nil
        {
            delegate!.didReceivedProductWithError(status: AppConstant.Static.CONNECTION_ERROR)
        }
        
        self.loader = nil
    }
    
    func processData(data data : NSData)
    {
        do
        {
            let result = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            let productModel = TodayProductModel()
            
            productModel.productDescription = result.objectForKey("ProductDescription") as! String!
            productModel.mrp = result.objectForKey("MRP") as! String!
            productModel.moreImages = result.objectForKey("MoreImages") as! [String!]!
            productModel.offerPrice = result.objectForKey("OfferPrice") as! String!
            productModel.productId = result.objectForKey("ProductId") as! String!
            productModel.productImage = result.objectForKey("ProductImage") as! String!
            productModel.productName = result.objectForKey("ProductName") as! String!
            productModel.productRemark = result.objectForKey("ProductRemark") as! String!
            productModel.shippingCharge = result.objectForKey("ShippingCharges") as! String!
            
            var moreImagesArray = result.objectForKey("ProductMoreImages") as! [NSDictionary]!
            
            productModel.productMoreImages = []
            for j in 0..<moreImagesArray.count
            {
                let moreImagesDict = moreImagesArray[j]
                let productMoreImages = ProductMoreImagesModel()
                
                productMoreImages.imageURL = moreImagesDict.objectForKey("ImageURL") as! String!
                productMoreImages.iOsColor = moreImagesDict.objectForKey("iOsColor") as! String!
                productMoreImages.androidColor = moreImagesDict.objectForKey("AndroidColor") as! String!
                
                productModel.productMoreImages!.append(productMoreImages)
            }
            
            if delegate != nil
            {
                delegate!.didReceivedProduct(product: productModel)
            }
        }
        catch
        {
            if delegate != nil
            {
                delegate!.didReceivedProductWithError(status: AppConstant.Static.PROCESSING_ERROR)
            }
        }
    }
}