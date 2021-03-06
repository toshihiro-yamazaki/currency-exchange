//
//  CurrencyListInteractor.swift
//  CurrencyExchange
//
//  Created by Toshihiro Nojima on 2019/03/22.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import ObjectMapper

class CurrencyListInteractor {
    
    let api: RevolutAPIProtocol
    
    init(api: RevolutAPIProtocol) {
        self.api = api
    }
    
    func getCurrencyList(base: String,
                         baseAmount: Double,
                         success: @escaping ([CurrencyModel]) -> Void,
                         failure: @escaping (Error) -> Void) {
        api.getLatestExchangeRates(
            params: ["base": base],
            success: { entity in
                var currencyList = [CurrencyModel]()
                entity.rates[base] = 1.0
                entity.rates.sorted { $0.0 < $1.0 }.forEach { arg in
                    let (key, value) = arg
                    if let code = CurrencyCode(rawValue: key),
                        let rate = value as? Double {
                        let amount = (baseAmount * rate).truncate(CurrencyModel.maxDicimalPlaces)
                        currencyList.append(CurrencyModel(code: code, rate: rate, amount: amount))
                    }
                }
                success(currencyList)
        }, failure: failure)
    }
    
    func getCurrencyRates(base: String,
                          success: @escaping ([Double]) -> Void,
                          failure: @escaping (Error) -> Void) {
        api.getLatestExchangeRates(
            params: ["base": base],
            success: { entity in
                var rates = [Double]()
                entity.rates[base] = 1.0
                entity.rates.sorted { $0.0 < $1.0 }.forEach { arg in
                    let (_, value) = arg
                    if let rate = value as? Double {
                        rates.append(rate)
                    }
                }
                success(rates)
        }, failure: failure)
    }
}
