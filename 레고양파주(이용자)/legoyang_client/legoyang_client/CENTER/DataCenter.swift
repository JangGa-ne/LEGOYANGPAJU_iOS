//
//  DataCenter.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/17.
//

import Foundation

//    var <#name#>: String = ""
//    func SET_<#name#>(<#name#>: Any) { self.<#name#> = <#name#> as? String ?? "" }

class API_STORE {
    
    var DELIVERY_TIME: String = ""
    var DISTANCE: String = ""
    var FCM_ID: String = ""
    var FOOD_TYPE: String = ""
    var ITEM_STAMP: String = ""
    var LAT: String = ""
    var LEDELIVERY_FEE: String = ""
    var LEDELIVERY_TIME: String = ""
    var LIKE_COUNT: Int = 0
    var LON: String = ""
    var MG_NAME: String = ""
    var MG_PHONE: String = ""
    var ON_BIRTH: String = ""
    var ON_NAME: String = ""
    var ON_PHONE: String = ""
    var PP_IMAGE: String = ""
    var PP_MENU: String = ""
    var PP_REMAIN: Int = 0
    var POINT_COUNT: String = ""
    var ST_ADDRESS: String = ""
    var ST_CASH: String = ""
    var ST_CATEGORY: String = ""
    var ST_COLOR: String = ""
    var ST_EMAIL: String = ""
    var ST_ETC: String = ""
    var ST_ID: String = ""
    var ST_IMAGE: String = ""
    var ST_IMAGES: [String] = []
    var ST_LASTORDER: String = ""
    var ST_MENU: [API_ST_MENU] = []
    var ST_NAME: String = ""
    var ST_OPEN: String = ""
    var ST_PW: String = ""
    var ST_POINT: String = ""
    var ST_REGNUM: String = ""
    var ST_RESTDAY: String = ""
    var ST_SUB_TITLE: String = ""
    var ST_TAG: [String] = []
    var ST_TAX_EMAIL: String = ""
    var ST_TEL: String = ""
    var ST_TIME: String = ""
    var USE_ITEM_TIME: String = ""
    var USE_PANGPANG: String = ""
    var VIEW_COUNT: Int = 0
    var WAITING_STEP: String = ""
    
    func SET_DELIVERY_TIME(DELIVERY_TIME: Any) { self.DELIVERY_TIME = DELIVERY_TIME as? String ?? "" }
    func SET_DISTANCE(DISTANCE: Any) { self.DISTANCE = DISTANCE as? String ?? "" }
    func SET_FCM_ID(FCM_ID: Any) { self.FCM_ID = FCM_ID as? String ?? "" }
    func SET_FOOD_TYPE(FOOD_TYPE: Any) { self.FOOD_TYPE = FOOD_TYPE as? String ?? "" }
    func SET_ITEM_STAMP(ITEM_STAMP: Any) { self.ITEM_STAMP = ITEM_STAMP as? String ?? "" }
    func SET_LAT(LAT: Any) { self.LAT = LAT as? String ?? "" }
    func SET_LEDELIVERY_FEE(LEDELIVERY_FEE: Any) { self.LEDELIVERY_FEE = LEDELIVERY_FEE as? String ?? "" }
    func SET_LEDELIVERY_TIME(LEDELIVERY_TIME: Any) { self.LEDELIVERY_TIME = LEDELIVERY_TIME as? String ?? "" }
    func SET_LIKE_COUNT(LIKE_COUNT: Any) { self.LIKE_COUNT = LIKE_COUNT as? Int ?? 0 }
    func SET_LON(LON: Any) { self.LON = LON as? String ?? "" }
    func SET_MG_NAME(MG_NAME: Any) { self.MG_NAME = MG_NAME as? String ?? "" }
    func SET_MG_PHONE(MG_PHONE: Any) { self.MG_PHONE = MG_PHONE as? String ?? "" }
    func SET_ON_BIRTH(ON_BIRTH: Any) { self.ON_BIRTH = ON_BIRTH as? String ?? "" }
    func SET_ON_NAME(ON_NAME: Any) { self.ON_NAME = ON_NAME as? String ?? "" }
    func SET_ON_PHONE(ON_PHONE: Any) { self.ON_PHONE = ON_PHONE as? String ?? "" }
    func SET_PP_IMAGE(PP_IMAGE: Any) { self.PP_IMAGE = PP_IMAGE as? String ?? "" }
    func SET_PP_MENU(PP_MENU: Any) { self.PP_MENU = PP_MENU as? String ?? "" }
    func SET_PP_REMAIN(PP_REMAIN: Any) { self.PP_REMAIN = PP_REMAIN as? Int ?? 0 }
    func SET_POINT_COUNT(POINT_COUNT: Any) { self.POINT_COUNT = POINT_COUNT as? String ?? "" }
    func SET_ST_ADDRESS(ST_ADDRESS: Any) { self.ST_ADDRESS = ST_ADDRESS as? String ?? "" }
    func SET_ST_CASH(ST_CASH: Any) { self.ST_CASH = ST_CASH as? String ?? "" }
    func SET_ST_CATEGORY(ST_CATEGORY: Any) { self.ST_CATEGORY = ST_CATEGORY as? String ?? "" }
    func SET_ST_COLOR(ST_COLOR: Any) { self.ST_COLOR = ST_COLOR as? String ?? "" }
    func SET_ST_EMAIL(ST_EMAIL: Any) { self.ST_EMAIL = ST_EMAIL as? String ?? "" }
    func SET_ST_ETC(ST_ETC: Any) { self.ST_ETC = ST_ETC as? String ?? "" }
    func SET_ST_ID(ST_ID: Any) { self.ST_ID = ST_ID as? String ?? "" }
    func SET_ST_IMAGE(ST_IMAGE: Any) { self.ST_IMAGE = ST_IMAGE as? String ?? "" }
    func SET_ST_IMAGES(ST_IMAGES: Any) { self.ST_IMAGES = ST_IMAGES as? [String] ?? [] }
    func SET_ST_LASTORDER(ST_LASTORDER: Any) { self.ST_LASTORDER = ST_LASTORDER as? String ?? "" }
    func SET_ST_MENU(ST_MENU: Any) { self.ST_MENU = ST_MENU as? [API_ST_MENU] ?? [] }
    func SET_ST_NAME(ST_NAME: Any) { self.ST_NAME = ST_NAME as? String ?? "" }
    func SET_ST_OPEN(ST_OPEN: Any) { self.ST_OPEN = ST_OPEN as? String ?? "" }
    func SET_ST_PW(ST_PW: Any) { self.ST_PW = ST_PW as? String ?? "" }
    func SET_ST_POINT(ST_POINT: Any) { self.ST_POINT = ST_POINT as? String ?? "" }
    func SET_ST_REGNUM(ST_REGNUM: Any) { self.ST_REGNUM = ST_REGNUM as? String ?? "" }
    func SET_ST_RESTDAY(ST_RESTDAY: Any) { self.ST_RESTDAY = ST_RESTDAY as? String ?? "" }
    func SET_ST_SUB_TITLE(ST_SUB_TITLE: Any) { self.ST_SUB_TITLE = ST_SUB_TITLE as? String ?? "" }
    func SET_ST_TAG(ST_TAG: Any) { self.ST_TAG = ST_TAG as? [String] ?? [] }
    func SET_ST_TAX_EMAIL(ST_TAX_EMAIL: Any) { self.ST_TAX_EMAIL = ST_TAX_EMAIL as? String ?? "" }
    func SET_ST_TEL(ST_TEL: Any) { self.ST_TEL = ST_TEL as? String ?? "" }
    func SET_ST_TIME(ST_TIME: Any) { self.ST_TIME = ST_TIME as? String ?? "" }
    func SET_USE_ITEM_TIME(USE_ITEM_TIME: Any) { self.USE_ITEM_TIME = USE_ITEM_TIME as? String ?? "" }
    func SET_USE_PANGPANG(USE_PANGPANG: Any) { self.USE_PANGPANG = USE_PANGPANG as? String ?? "" }
    func SET_VIEW_COUNT(VIEW_COUNT: Any) { self.VIEW_COUNT = VIEW_COUNT as? Int ?? 0 }
    func SET_WAITING_STEP(WAITING_STEP: Any) { self.WAITING_STEP = WAITING_STEP as? String ?? "" }
}

class API_ST_MENU {
    
    var MENU_NAME: String = ""
    var MENU_PRICE: String = ""
    
    func SET_MENU_NAME(MENU_NAME: Any) { self.MENU_NAME = MENU_NAME as? String ?? "" }
    func SET_MENU_PRICE(MENU_PRICE: Any) { self.MENU_PRICE = MENU_PRICE as? String ?? "" }
}

// var <#name#>: String = ""
// func SET_<#name#>(<#name#>: Any) { self.<#name#> = <#name#> as? String ?? "" }

struct API_USER {
    
    var BENEFIT_POINT: String = ""
    var DELIVERY_ADDRESS: [String] = []
    var FCM_ID: String = ""
    var FREE_DELIVERY_COUPON: Int = 0
    var GRADE: String = ""
    var ID: String = ""
    var LAT: String = ""
    var LEGONGGU_TOPIC: String = ""
    var LON: String = ""
    var MYLIKE_STORE: [String] = []
    var NAME: String = ""
    var NICK: String = ""
    var NOTI_LIST: [API_NOTI_LIST] = []
    var PASSWORD: String = ""
    var NUMBER: String = ""
    var PANGPANG_TOPIC: String = ""
    var PLATFORM: String = ""
    var POINT: String = ""
    var PROFILE_IMG: String = ""
    var SECESSION: String = ""
    var SIGNUP_TIME: String = ""
}

class API_NOTI_LIST {
    
    var BODY: String = ""
    var DATA: String = ""
    var READORNOT: String = ""
    var RECEIVE_TIME: String = ""
    var TIMESTAMP: String = ""
    var TITLE: String = ""
    var TYPE: String = ""
    
    func SET_BODY(BODY: Any) { self.BODY = BODY as? String ?? "" }
    func SET_DATA(DATA: Any) { self.DATA = DATA as? String ?? "" }
    func SET_READORNOT(READORNOT: Any) { self.READORNOT = READORNOT as? String ?? "" }
    func SET_RECEIVE_TIME(RECEIVE_TIME: Any) { self.RECEIVE_TIME = RECEIVE_TIME as? String ?? "" }
    func SET_TIMESTAMP(TIMESTAMP: Any) { self.TIMESTAMP = TIMESTAMP as? String ?? "" }
    func SET_TITLE(TITLE: Any) { self.TITLE = TITLE as? String ?? "" }
    func SET_TYPE(TYPE: Any) { self.TYPE = TYPE as? String ?? "" }
}


