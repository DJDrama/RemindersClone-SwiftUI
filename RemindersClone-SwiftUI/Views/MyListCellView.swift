//
//  MyListCellView.swift
//  RemindersClone-SwiftUI
//
//  Created by Dongjun Lee on 11/11/24.
//

import Foundation
import SwiftUI

struct MyListCellView: View {
    let myList: MyList
    var body: some View {
        HStack {
            Image(systemName: "line.3.horizontal.circle.fill")
                .font(.system(size: 32))
                .foregroundStyle(Color.init(hex: myList.colorCode))
            
            Text(myList.name)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
