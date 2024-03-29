import Flutter
import UIKit
import AdBrixRmKit

public class SwiftAdbrixrmFlutterPlugin: NSObject, FlutterPlugin, AdBrixRMDeeplinkDelegate, AdBrixRMDeferredDeeplinkDelegate {
    
    var myDeferredDeeplink : String = ""
    var myDeeplink : String = ""
    
    
    public func didReceiveDeeplink(deeplink: String) {
        myDeeplink = deeplink
        
    }
    
    public func didReceiveDeferredDeeplink(deeplink: String) {
        myDeferredDeeplink = deeplink
        
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "adbrixrm_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftAdbrixrmFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        let methodName : String = call.method
        let adBrix = AdBrixRM.getInstance
        
        func sdkInit (_ call : FlutterMethodCall){
            
            let args = call.arguments as? [String : Any]
            let appKey = args?["AppKey"] as! String
            let secretKey = args?["SecretKey"] as! String
            
            adBrix.initAdBrix(appKey: appKey, secretKey: secretKey)
            
            adBrix.didBecomeActive()
                
            adBrix.delegateDeferredDeeplink = self
            adBrix.delegateDeeplink = self
        }
        
        func adbrixDeferredDeeplink (deferredDeeplink : String, result : @escaping FlutterResult) {
            
            if deferredDeeplink != "" {
                result (deferredDeeplink)
                myDeferredDeeplink = ""
            } else {
                result(nil)
            }
        }
        
        func adbrixDeeplink (deeplink : String, result : @escaping FlutterResult) {
            
            if deeplink != "" {
                result (deeplink)
                myDeeplink = ""
            } else {
                result(nil)
            }
        }
                
        func setEventUploadCountInterval (_ call: FlutterMethodCall) {
            
            let arg = call.arguments as! String
                        
            switch arg {
            case "MIN":
                adBrix.setEventUploadCountInterval(AdBrixRM.AdBrixEventUploadCountInterval.MIN)
            case "NORMAL" :
                adBrix.setEventUploadCountInterval(AdBrixRM.AdBrixEventUploadCountInterval.NORMAL)
            case "MAX" :
                adBrix.setEventUploadCountInterval(AdBrixRM.AdBrixEventUploadCountInterval.MAX)
            default:
                print("AdBrixRm Flutter plugin")
            }
        }
        
        func setEventUploadTimeInterval (_ call: FlutterMethodCall) {
            
            let arg = call.arguments as! String
            switch arg {
            case "MIN":
                adBrix.setEventUploadTimeInterval(AdBrixRM.AdBrixEventUploadTimeInterval.MIN)
            case "NORMAL" :
                adBrix.setEventUploadTimeInterval(AdBrixRM.AdBrixEventUploadTimeInterval.NORMAL)
            case "MAX" :
                adBrix.setEventUploadTimeInterval(AdBrixRM.AdBrixEventUploadTimeInterval.MAX)
            default:
                print("AdBrixRm Flutter plugin")
            }
        }
        
        func startGettingIDFA () {
            adBrix.startGettingIDFA();
        }
        
        func stopGettingIDFA () {
            adBrix.stopGettingIDFA();
        }
        
        func gdprForgetMe () {
            
            adBrix.gdprForgetMe()
        }
        
        func setAge (_ call : FlutterMethodCall) {
            
            let arg = call.arguments as! Int
            adBrix.setAge(int: arg)
        }
        
        func setKakaoId(_ call : FlutterMethodCall){
            
            let kakaoId = call.arguments as! String
            adBrix.setKakaoId(kakaoId: kakaoId)
            
        }
        
        func setGender (_ call : FlutterMethodCall) {
            
            let arg = call.arguments as! String
            switch arg {
            case "FEMALE":
                adBrix.setGender(adBrixGenderType: AdBrixRM.AdBrixGenderType.Female)
            case "MALE" :
                adBrix.setGender(adBrixGenderType: AdBrixRM.AdBrixGenderType.Male)
            case "UNKNOWN" :
                adBrix.setGender(adBrixGenderType: AdBrixRM.AdBrixGenderType.Unknown)
            default:
                print("AdBrixRm Flutter plugin")
            }
        }
        
        func setUserProperties (_ call : FlutterMethodCall) {
            
            let arg = call.arguments as! Dictionary<String, Any>
            let userProperties = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: arg)
            adBrix.setUserPropertiesWithAttr(attrModel: userProperties)
            
        }
        
        func setCiProperties (_ call : FlutterMethodCall) {
            
            let arg = call.arguments as! Dictionary<String, Any>
            let ciProperties = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: arg)
            adBrix.setUserCiWithAttr(attrModel: ciProperties)
            
        }
        
        func events (_ call : FlutterMethodCall) {
            
            let args = call.arguments as? [String : Any]
            let eventName = args?["eventName"] as! String
            let attr = args?["attr"] as! Dictionary<String, Any>?
            
            if attr != nil{
                let eventAttr = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: attr!)
                adBrix.eventWithAttr(eventName: eventName, value: eventAttr)
                
            } else {
                adBrix.event(eventName: eventName)
                
            }
        }
        
        func login (_ call : FlutterMethodCall) {
            
            let args = call.arguments as? [String : Any]
            let userId = args?["userId"] as! String
            
            adBrix.login(userId: userId)
            
        }
        
        func logout (){
            adBrix.logout();
        }
        
        func commonSignUp (_ call : FlutterMethodCall) {
            
            let args = call.arguments as? [String : Any]
            let channel = args?["channel"] as! Int
            let attr = args?["attr"] as! Dictionary<String, Any>?
            
            if attr != nil {
                let eventAttr = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: attr!)
                adBrix.commonSignUpWithAttr(channel: AdBrixRM.AdBrixRmSignUpChannel.init(rawValue: channel)!, commonAttr: eventAttr)
                
            } else {
                adBrix.commonSignUp(channel: AdBrixRM.AdBrixRmSignUpChannel.init(rawValue: channel)!)
                
            }
        }
        
        func  commonAppUpdate (_ call : FlutterMethodCall) {
            
            let args = call.arguments as? [String : Any]
            let preVersion = args?["preVersion"] as! String
            let currVersion = args?["currVersion"] as! String
            let attr = args?["attr"] as! Dictionary<String, Any>?
            
            if attr != nil {
                let eventAttr = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: attr!)
                adBrix.commonAppUpdateWithAttr(prev_ver: preVersion, curr_ver: currVersion, commonAttr: eventAttr)
                
            }else {
                adBrix.commonAppUpdate(prev_ver: preVersion, curr_ver: currVersion)
                
            }
        }
        
        func commonUserInvite (_ call : FlutterMethodCall) {
            
            let args = call.arguments as? [String : Any]
            let channel = args?["inviteChannel"] as! Int
            let attr = args?["attr"] as! Dictionary<String, Any>?
            
            if attr != nil{
                let eventAttr = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: attr!)
                adBrix.commonInviteWithAttr(channel: AdBrixRM.AdBrixRmInviteChannel.init(rawValue: channel)!, commonAttr: eventAttr)
                
            }else {
                adBrix.commonInvite(channel: AdBrixRM.AdBrixRmInviteChannel.init(rawValue: channel)!)
                
            }
        }
        
        func commonUseCredit (_ call : FlutterMethodCall) {
            
            let args = call.arguments as? [String : Any]
            let attr = args?["attr"] as! Dictionary<String, Any>?
            
            if attr != nil {
                let eventAttr = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: attr!)
                adBrix.commonUseCreditWithAttr(commonAttr: eventAttr)
                
            }  else {
                adBrix.commonUseCredit()
                
            }
        }
        
        func gameTutorialComplete (_ call : FlutterMethodCall) {
            
            let args = call.arguments as? [String : Any]
            let isSkip = args?["isSkip"] as! Bool
            let attr = args?["attr"] as! Dictionary<String, Any>?
            
            if attr != nil {
                let eventAttr = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: attr!)
                adBrix.gameTutorialCompletedWithAttr(isSkip: isSkip, gameInfoAttr: eventAttr)
                
            } else {
                adBrix.gameTutorialCompleted(isSkip: isSkip)
                
            }
        }
        
        func gameCharacterCreated (_ call : FlutterMethodCall) {
            
            let args = call.arguments as? [String : Any]
            let attr = args?["attr"] as! Dictionary<String, Any>?
            
            if attr != nil {
                let eventAttr = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: attr!)
                adBrix.gameCharacterCreatedWithAttr(gameInfoAttr: eventAttr)
                
            } else {
                adBrix.gameCharacterCreated()
                
            }
        }
        
        func gameStageCleared (_ call : FlutterMethodCall) {
            
            let args = call.arguments as? [String : Any]
            let stageName = args?["stageName"] as! String
            let attr = args?["attr"] as! Dictionary<String, Any>?
            
            if attr != nil {
                let eventAttr = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: attr!)
                adBrix.gameStageClearedWithAttr(stageName: stageName, gameInfoAttr: eventAttr)
                
            } else {
                adBrix.gameStageCleared(stageName: stageName)
                
            }
        }
        
        func gameLevelAchieved (_ call : FlutterMethodCall) {
            
            let args = call.arguments as? [String : Any]
            let levelAchieved = args?["levelAchieved"] as! Int
            let attr = args?["attr"] as! Dictionary<String, Any>?
            
            if attr != nil {
                let eventAttr = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: attr!)
                adBrix.gameLevelAchievedWithAttr(level: levelAchieved, gameInfoAttr: eventAttr)
                
            } else {
                adBrix.gameLevelAchieved(level: levelAchieved)
                
            }
        }
        
        func commerceViewHome () {
            
            adBrix.commerceViewHome()
            
        }
        
        func commerceProductView (_ call : FlutterMethodCall) {
            
            let args = call.arguments as? [String : Any]
            let productModel = args?["productModel"] as! Dictionary<String, Any>
            let attr = args?["attr"] as! Dictionary<String, Any>?
            
            let productResult = AdBrixUtility.AdBrixRmMakeProductModel(productModel: productModel)
            
            if attr != nil {
                let eventAttr = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: attr!)
                adBrix.commerceProductViewWithAttr(productInfo: productResult, orderAttr: eventAttr)
                
            } else {
                adBrix.commerceProductView(productInfo:productResult)
                
            }
        }
        
        func commerceAddToWishList (_ call : FlutterMethodCall) {
            
            let args = call.arguments as? [String : Any]
            let productModel = args?["productModel"] as! Dictionary<String, Any>
            let attr = args?["attr"] as! Dictionary<String, Any>?
            
            let productResult = AdBrixUtility.AdBrixRmMakeProductModel(productModel: productModel)
            
            if attr != nil{
                let eventAttr = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: attr!)
                
                adBrix.commerceAddToWishListWithAttr(productInfo: productResult, orderAttr: eventAttr)
                
            }else {
                adBrix.commerceAddToWishList(productInfo: productResult)
                
            }
        }
        
        func commerceShare (_ call : FlutterMethodCall) {
            
            let args = call.arguments as? [String : Any]
            let productModel = args?["productModel"] as! Dictionary<String, Any>
            let attr = args?["attr"] as! Dictionary<String, Any>?
            let shareChannel = args?["sharingChannel"] as! String
            var sharingChannel = AdBrixRM.AdBrixRmSharingChannel.AdBrixRmSharingFacebook
            
            let productResult = AdBrixUtility.AdBrixRmMakeProductModel(productModel: productModel)
            
            switch shareChannel {
            case "FACEBOOK":
                sharingChannel = AdBrixRM.AdBrixRmSharingChannel.AdBrixRmSharingFacebook
            case "KAKAOTALK" :
                sharingChannel = AdBrixRM.AdBrixRmSharingChannel.AdBrixRmSharingKakaoTalk
            case "KAKAOSTORY" :
                sharingChannel = AdBrixRM.AdBrixRmSharingChannel.AdBrixRmSharingKakaoStory
            case "LINE" :
                sharingChannel = AdBrixRM.AdBrixRmSharingChannel.AdBrixRmSharingLine
            case "WHATSAPP" :
                sharingChannel = AdBrixRM.AdBrixRmSharingChannel.AdBrixRmSharingWhatsApp
            case "QQ" :
                sharingChannel = AdBrixRM.AdBrixRmSharingChannel.AdBrixRmSharingQQ
            case "WECHAT" :
                sharingChannel = AdBrixRM.AdBrixRmSharingChannel.AdBrixRmSharingWeChat
            case "SMS" :
                sharingChannel = AdBrixRM.AdBrixRmSharingChannel.AdBrixRmSharingSMS
            case "EMAIL" :
                sharingChannel = AdBrixRM.AdBrixRmSharingChannel.AdBrixRmSharingEmail
            case "COPYURL" :
                sharingChannel = AdBrixRM.AdBrixRmSharingChannel.AdBrixRmSharingCopyUrl
            case "ETC" :
                sharingChannel = AdBrixRM.AdBrixRmSharingChannel.AdBrixRmSharingETC
                
            default:
                debugPrint("peterworks :::::: there is something wrong with shareChannel")
                
            }
            
            if attr != nil  {
                let eventAttr = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: attr!)
                
                adBrix.commerceShareWithAttr(channel: sharingChannel, productInfo: productResult, orderAttr: eventAttr)
                
            }  else {
                adBrix.commerceShare(channel: sharingChannel, productInfo: productResult)
                
            }
            
        }
        
        func commercePaymentInfoAdd (_ call : FlutterMethodCall) {
            
            let args = call.arguments as? [String : Any]
            let attr = args?["attr"] as! Dictionary<String, Any>?
            
            if attr != nil{
                let eventAttr = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: attr!)
                
                adBrix.commercePaymentInfoAddedWithAttr(paymentInfoAttr: eventAttr)
                
            } else {
                
                adBrix.commercePaymentInfoAdded()
                
            }
            
        }
        
        func commonPurchase (_ call : FlutterMethodCall) {
            
            let args = call.arguments as? [String : Any]
            let attr = args?["attr"] as! Dictionary<String, Any>?
            let orderId = args?["orderId"] as! String
            let orderSale = args?["orderSale"] as! Double
            let productList = args?["productList"] as! Array<Dictionary<String,Any>>
            let discount = args?["discount"] as! Double
            let deliveryCharge = args? ["deliveryCharge"] as! Double
            let paymentMethodString = args? ["paymentMethod"] as! String
            
            var paymentMethod = AdBrixRM.AdbrixRmPaymentMethod.CreditCard
            
            switch paymentMethodString {
            case "CreditCard":
                paymentMethod = AdBrixRM.AdbrixRmPaymentMethod.CreditCard
            case "BankTransfer" :
                paymentMethod = AdBrixRM.AdbrixRmPaymentMethod.BankTransfer
            case "MobilePayment" :
                paymentMethod = AdBrixRM.AdbrixRmPaymentMethod.MobilePayment
            case "ETC" :
                paymentMethod = AdBrixRM.AdbrixRmPaymentMethod.ETC
            default:
                debugPrint("peterworks :::::: there is something wrong with payment")
                
            }
            
            
            let productListArr = AdBrixUtility.AdBrixRmMakeProductList(productList: productList)
            
            if attr != nil {
                let eventAttr = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: attr!)
                
                adBrix.commonPurchaseWithAttr(orderId: orderId, productInfo: productListArr, orderSales: orderSale, discount: discount, deliveryCharge: deliveryCharge, paymentMethod: paymentMethod, orderAttr: eventAttr)
                
            } else {
                
                adBrix.commonPurchase(orderId: orderId, productInfo: productListArr, orderSales: orderSale, discount: discount, deliveryCharge: deliveryCharge, paymentMethod: paymentMethod)
                
            }
            
            
            
        }
        
        func commerceCategoryView (_ call : FlutterMethodCall) {
            
            let args = call.arguments as? [String : Any]
            let attr = args?["attr"] as! Dictionary<String, Any>?
            let productList = args?["productList"] as! Array<Dictionary<String,Any>>
            let categoryList = args?["categoryModel"] as! Array<String>
            
            let productListArr = AdBrixUtility.AdBrixRmMakeProductList(productList: productList)
            let myCategory = AdBrixUtility.AdBrixRmMakeProductCategory(categoryList: categoryList)
            
            if attr != nil {
                
                let eventAttr = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: attr!)
                
                adBrix.commerceCategoryViewWithAttr(category: myCategory, productInfo: productListArr, orderAttr: eventAttr)
                
            } else {
                
                adBrix.commerceCategoryView(category: myCategory, productInfo: productListArr)
                
            }
            
        }
        
        func commerceAddToCart (_ call : FlutterMethodCall) {
            
            let args = call.arguments as? [String : Any]
            let attr = args?["attr"] as! Dictionary<String, Any>?
            let productList = args?["productList"] as! Array<Dictionary<String,Any>>
            
            let productListArr = AdBrixUtility.AdBrixRmMakeProductList(productList: productList)
            
            if attr != nil {
                
                let eventAttr = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: attr!)
                
                adBrix.commerceAddToCartWithAttr(productInfo: productListArr, orderAttr: eventAttr)
                
            } else {
                
                adBrix.commerceAddToCart(productInfo: productListArr)
            }
            
        }
        
        
        
        func commerceReviewOrder (_ call : FlutterMethodCall) {
            
            let args = call.arguments as? [String : Any]
            let attr = args?["attr"] as! Dictionary<String, Any>?
            let orderId = args?["orderId"] as! String
            let productList = args?["productList"] as! Array<Dictionary<String,Any>>
            let discount = args?["discount"] as! Double
            let deliveryCharge = args? ["deliveryCharge"] as! Double
            
            let productListArr = AdBrixUtility.AdBrixRmMakeProductList(productList: productList)
            
            if attr != nil {
                
                let eventAttr = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: attr!)
                
                adBrix.commerceReviewOrderWithAttr(orderId: orderId, productInfo: productListArr, discount: discount, deliveryCharge: deliveryCharge, orderAttr: eventAttr)
                
            } else {
                
                adBrix.commerceReviewOrder(orderId: orderId, productInfo: productListArr, discount: discount, deliveryCharge: deliveryCharge)
                
            }
            
        }
        
        func commerceRefund (_ call : FlutterMethodCall) {
            
            let args = call.arguments as? [String : Any]
            let attr = args?["attr"] as! Dictionary<String, Any>?
            let orderId = args?["orderId"] as! String
            let productList = args?["productList"] as! Array<Dictionary<String,Any>>
            let penaltyCharge = args?["penaltyCharge"] as! Double
            
            let productListArr = AdBrixUtility.AdBrixRmMakeProductList(productList: productList)
            
            if attr != nil {
                
                let eventAttr = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: attr!)
                
                adBrix.commerceRefundWithAttr(orderId: orderId, productInfo: productListArr, penaltyCharge: penaltyCharge, orderAttr: eventAttr)
                
            } else {
                
                adBrix.commerceRefund(orderId: orderId, productInfo: productListArr, penaltyCharge: penaltyCharge)
                
            }
            
        }
        
        func commerceSearch (_ call : FlutterMethodCall) {
            
            let args = call.arguments as? [String : Any]
            let attr = args?["attr"] as! Dictionary<String, Any>?
            let keyword = args?["keyword"] as! String
            let productList = args?["productList"] as! Array<Dictionary<String,Any>>
            
            let productListArr = AdBrixUtility.AdBrixRmMakeProductList(productList: productList)
            
            
            if attr != nil {
                
                let eventAttr = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: attr!)
                
                adBrix.commerceSearchWithAttr(productInfo: productListArr, keyword: keyword, orderAttr: eventAttr)
                
            }
            
            else {
                
                adBrix.commerceSearch(productInfo: productListArr, keyword: keyword)
            }
        }
        
        func commerceListView (_ call : FlutterMethodCall) {
            
            let args = call.arguments as? [String : Any]
            let attr = args?["attr"] as! Dictionary<String, Any>?
            let productList = args?["productList"] as! Array<Dictionary<String,Any>>
            
            let productListArr = AdBrixUtility.AdBrixRmMakeProductList(productList: productList)
            
            if attr != nil {
                
                let eventAttr = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: attr!)
                
                adBrix.commerceListViewWithAttr(productInfo: productListArr, orderAttr: eventAttr)
                
            }
            
            else {
                
                adBrix.commerceListView(productInfo: productListArr)
                
            }
            
        }
        
        func commerceCartView (_ call : FlutterMethodCall) {
            
            let args = call.arguments as? [String : Any]
            let attr = args?["attr"] as! Dictionary<String, Any>?
            let productList = args?["productList"] as! Array<Dictionary<String,Any>>
            
            let productListArr = AdBrixUtility.AdBrixRmMakeProductList(productList: productList)
            
            if attr != nil {
                
                let eventAttr = AdBrixUtility.AdBrixRmAttrModelMakeAttrModel(attr: attr!)
                
                adBrix.commerceCartViewWithAttr(productInfo: productListArr, orderAttr: eventAttr)
                
            }
            
            else {
                
                adBrix.commerceCartView(productInfo: productListArr)
                
            }
            
        }
        
        
        // event Controller
        
        switch methodName {
        case "sdkInit":
            sdkInit (call)
        case "setEventUploadCountInterval" :
            setEventUploadCountInterval (call)
        case"setEventUploadTimeInterval" :
            setEventUploadTimeInterval (call)
        case "gdprForgetMe" :
            gdprForgetMe ()
        case "setAge":
            setAge (call)
        case "setGender":
            setGender (call)
        case "setUserProperties" :
            setUserProperties (call)
        case "events" :
            events (call)
        case "login" :
            login (call)
        case "logout" :
            logout()
        case "commonSignUp":
            commonSignUp (call)
        case "appUpdate" :
            commonAppUpdate (call)
        case "userInvite" :
            commonUserInvite (call)
        case "useCredit" :
            commonUseCredit (call)
        case "gameTutorialComplete" :
            gameTutorialComplete (call)
        case "gameCharacterCreated" :
            gameCharacterCreated (call)
        case "gameStageCleared" :
            gameStageCleared (call)
        case "gameLevelAchieved":
            gameLevelAchieved (call)
        case "commerceViewHome" :
            commerceViewHome ()
        case "commerceProductView" :
            commerceProductView (call)
        case "commerceAddToWishList" :
            commerceAddToWishList (call)
        case "commerceShare" :
            commerceShare (call)
        case "commercePaymentInfoAdd" :
            commercePaymentInfoAdd (call)
        case "commonPurchase" :
            commonPurchase (call)
        case "commerceCategoryView" :
            commerceCategoryView(call)
        case "commerceAddToCart" :
            commerceAddToCart (call)
        case "commerceReviewOrder" :
            commerceReviewOrder (call)
        case "commerceRefund" :
            commerceRefund (call)
        case "commerceSearch" :
            commerceSearch (call)
        case "commerceListView" :
            commerceListView (call)
        case "commerceCartView" :
            commerceCartView (call)
        case "adbrixDeferredDeeplink" :
            adbrixDeferredDeeplink(deferredDeeplink: myDeferredDeeplink, result: result)
        case "adbrixDeeplink" :
            adbrixDeeplink(deeplink: myDeeplink, result: result)
        case "startGettingIDFA" :
            startGettingIDFA()
        case "stopGettingIDFA" :
            stopGettingIDFA()
        case "setKakaoId" :
            setKakaoId(call)
        case "setCiProperties" :
            setCiProperties(call)
        default:
            print("AdBrixRm Flutter plugin")
        }
    }
}
