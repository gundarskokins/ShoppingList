//
//  DropdownPicker.swift
//  Shopping List
//
//  Created by Gundars Kokins on 16/05/2021.
//

import Foundation
import SwiftUI

struct DropdownPicker: View {
    
    var title: String
    @Binding var selection: String
    var options: [String]
    
    @State private var showOptions: Bool = false
    @State private var isTextHidden: Bool = false
    @State private var selectionIndex = 0
    
    var body: some View {
        ZStack {
            // Static row which shows user's current selection
            if !isTextHidden {
                HStack {
                    Text(title)
                    Spacer()
                    let selectedBasket: String = {
                        if let index = options.firstIndex(of: selection) {
                            return options[index]
                        }
                        return ""
                    }()
                    Text(selectedBasket)
                        .opacity(0.6)
                    Image(systemName: "chevron.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 10, height: 10)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .onTapGesture {
                    // show the dropdown options
                    withAnimation(Animation.spring().speed(2)) {
                        isTextHidden = true
                        showOptions = true
                    }
                }
            }
            
            // Drop down options
            if showOptions {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .fontWeight(.semibold)
                    HStack {
                        Spacer()
                        Picker("Selection", selection: $selectionIndex) {
                            ForEach(options.indices, id: \.self) { index in
                                Text(options[index])
                            }
                        }
                        .onTapGesture {
                            // hide dropdown options - user selection didn't change
                            selection = options[selectionIndex]
                            withAnimation(Animation.spring().speed(2)) {
                                isTextHidden = false
                                showOptions = false
                            }
                        }
                    }
                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                    
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .transition(.opacity)
            }
            
        }
    }
}
