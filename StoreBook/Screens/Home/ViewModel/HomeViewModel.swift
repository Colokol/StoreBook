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


