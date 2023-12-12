//
//  HomeViewModel.swift
//  StoreBook
//
//  Created by Vadim Zhelnov on 10.12.23.
//

import Foundation
import Combine

final class HomeViewModel{
    @Published var topBook:[TopBook] = []
    var subscription:Set<AnyCancellable> = []
    
    
    init(){
        self.getData(period: .daily)
    }
    public func getData(period:TimeFrame){
            NetworkManager.shared.getTopBook(for: period)
                .receive(on: DispatchQueue.main)
                .sink { error in
                    print(error)
                } receiveValue: { value in
                    self.topBook = value.works
                    
                }
                .store(in: &subscription)
        }
    }

//        switch period{
//        case .weekly:
//            NetworkManager.shared.getTopBook(for: .weekly)
//                .receive(on: DispatchQueue.main)
//                .sink { error in
//                    print(error)
//                } receiveValue: { value in
//                    self.topBook = value.works
//                }
//                .store(in: &subscription)
//        case .monthly:
//            NetworkManager.shared.getTopBook(for: .monthly)
//                .receive(on: DispatchQueue.main)
//                .sink { error in
//                    print(error)
//                } receiveValue: { value in
//                    self.topBook = value.works
//                }
//                .store(in: &subscription)
//        case .yearly:
//            NetworkManager.shared.getTopBook(for: .yearly)
//                .receive(on: DispatchQueue.main)
//                .sink { error in
//                    print(error)
//                } receiveValue: { value in
//                    self.topBook = value.works
//                }
//                .store(in: &subscription)
//        default:
