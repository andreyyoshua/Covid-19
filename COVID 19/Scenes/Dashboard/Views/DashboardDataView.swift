//
//  DashboardDataView.swift
//  COVID 19
//
//  Created by Andrey Yoshua Manik on 08/03/20.
//  Copyright © 2020 Brid. All rights reserved.
//

import SwiftUI

struct DashboardDataView: View {
    let title: String
    let dashboardCase: DashboardEnum
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                if self.title.isEmpty {
                    ActivityIndicator(
                        isAnimating: Binding<Bool>(
                            get: {
                                true
                            },
                            set: { isAnimating in
                            
                            }),
                        style: .large)
                }
                Text(self.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(self.dashboardCase.textColor)
                    .lineLimit(1)
                    .frame(width: geo.size.width)
                Text(self.dashboardCase.rawValue)
                    .fontWeight(.light)
                    .foregroundColor(self.dashboardCase.textColor)
                    .lineLimit(1)
                    .frame(width: geo.size.width)
            }
            .padding(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 4))
            .background(self.dashboardCase.backgroundColor)
            .cornerRadius(10)
            .shadow(radius: 3)
        }
    }
}

struct DashboardDataView_Previews: PreviewProvider {
    @State static var selected: Bool = true
    static var previews: some View {
        DashboardDataView(title: "103.165", dashboardCase: .death)
    }
}
