//
//  MapsView.swift
//  COVID 19
//
//  Created by Andrey Yoshua Manik on 08/03/20.
//  Copyright © 2020 Brid. All rights reserved.
//

import SwiftUI

struct MapsView: View {
    
    @ObservedObject private var viewModel = DetailViewModel()
    var detailUrl: String
    var dashboardCase: DashboardEnum
    @State var isBottomSheetOpen = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                MapSwiftUIView(
                    locations: Binding<[[Double]]>(
                        get: {
                            self.viewModel.details.map { [$0.lat, $0.long]}
                        },
                        set: { (locations) in }
                    ),
                    annotationHandler: MapAnnotationView(dashboardCase: self.dashboardCase))
                    .edgesIgnoringSafeArea(.all)

                BottomSheetView(
                    isOpen: .init(
                        get: {
                            self.viewModel.keyboardShowing
                        },
                        set: { isOpen in
                            self.viewModel.keyboardShowing = isOpen
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }),
                    maxHeight: geo.size.height) {
                    VStack {
                        TextField("Please input your city",
                                  text: self.$viewModel.keyword)
                            .frame(width: geo.size.width * 0.9, height: 40)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(10)
                            
                        List {
                            ForEach(self.viewModel.details, id: \.self) { detail in
                                VStack(alignment: .leading) {
                                    Text(detail.countryRegion)
                                        .fontWeight(.bold)
                                    if self.dashboardCase == .infected {
                                        Text("Infected \(detail.confirmed)")
                                            .fontWeight(.semibold)
                                            .foregroundColor(self.dashboardCase.backgroundColor)
                                    } else if self.dashboardCase == .recovered {
                                        Text("Recovered \(detail.recovered)")
                                            .fontWeight(.semibold)
                                            .foregroundColor(self.dashboardCase.backgroundColor)
                                    } else if self.dashboardCase == .death {
                                        Text("Death \(detail.deaths)")
                                            .fontWeight(.semibold)
                                            .foregroundColor(self.dashboardCase.backgroundColor)
                                    }
                                    Text("Last update \(detail.lastUpdate.shortFormat)")
                                }
                            }
                        }
                    }
                    .navigationBarHidden(true)
                }
                .edgesIgnoringSafeArea(.all)
            }
            .onAppear {
                self.viewModel.getDetail(urlString: self.detailUrl)
            }
        }
    }
}

struct MapsView_Previews: PreviewProvider {
    static var url = "https://covid19.mathdro.id/api/confirmed"
    static var previews: some View {
        MapsView(detailUrl: url, dashboardCase: .infected)
    }
}
