//
//  TodayProductModel.swift
//  POD
//
//  Created by Shareen Ali on 04/07/16.
//  Copyright © 2016 Shareen Ali. All rights reserved.
//

import UIKit

class TodayProductModel: NSObject
{
    var androidColor : String?
    var categoryId : String?
    var categoryName : String?
    var productDescription : String?
    var isMultiple : String?
    var mrp : String?
    var maxQty : String?
    var moreImages : [String!]?
    var offerPrice : String?
    var productId : String?
    var productImage : String?
    var productName : String?
    var productRemark : String?
    var shippingCharge : String?
    var termsAndConditions : String?
    var today : String?
    var totalQty : Double?
    var iOsColor : String?
    
    var productMoreImages : [ProductMoreImagesModel!]?
}

/*
 "ProductMoreImages":[{
 "ImageURL":"String content",
 "iOsColor":"String content",
 "AndroidColor":"String content"
 }],
 */
