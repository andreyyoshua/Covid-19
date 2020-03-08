//
//  DashboardView.swift
//  COVID 19
//
//  Created by Andrey Yoshua Manik on 08/03/20.
//  Copyright © 2020 Brid. All rights reserved.
//

import SwiftUI
import SunburstDiagram

struct DashboardView: View {
    
    @ObservedObject private var viewModel = DashboardViewModel()
    
    private let locationManager: MapLocationManager = MapLocationManager { (location) in
        
    }
    
    private func getDataFor(_ dashboardCase: DashboardEnum) -> DashboardData {
        switch dashboardCase {
            case .infected:
                return self.viewModel.confirmedCase
            case .recovered:
                return self.viewModel.recoveredCase
            case .death:
                return self.viewModel.deathCase
        }
    }
    
    private func createChartConfiguration() -> SunburstConfiguration {
        let config = SunburstConfiguration(
            nodes: DashboardEnum.allCases.map {
                Node(
                    name: "",
                    showName: false,
                    value: Double(self.getDataFor($0).value),
                    backgroundColor: $0.backgroundColor.uiColor
                )
            }
        )
        let total = config.nodes.map { $0.value ?? 0 }.reduce(0, +)
        config.allowsSelection = false
        config.innerRadius = 0
        config.marginBetweenArcs = 1
        config.calculationMode = .parentDependent(totalValue: total)
        return config
    }
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                List {
                    Section(header:
                        VStack {
                            Spacer()
                                .frame(height: 10)
                            
                            HStack {
                                SunburstView(configuration: self.createChartConfiguration())
                                    .frame(width: geo.size.width * 0.4, height: 320)
                                VStack {
                                    ForEach(DashboardEnum.allCases, id: \.self) { dashboardCase in
                                        NavigationLink(destination: MapsView(detailUrl: self.getDataFor(dashboardCase).detail, dashboardCase: dashboardCase)) {
                                            DashboardDataView(
                                                title: "\(self.getDataFor(dashboardCase).value)",
                                                dashboardCase: dashboardCase
                                            )
                                            .frame(width: geo.size.width * 0.4)
                                        }
                                    }
                                }
                            }
                            .frame(width: geo.size.width * 0.95)
                            .background(Color.black)
                            .shadow(radius: 3)
                            .cornerRadius(10)
                            
                            Text("Daily Updates")
                                .padding(10)
                        },
                        content:  {
                            ForEach((0..<self.viewModel.daily.count).reversed(), id: \.self) { i in
                                DailyView(daily: self.viewModel.daily[i], lastDaily: self.viewModel.daily[i - 1])
                                .frame(height: 100)
                            }
                        })
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("COVID-19")
            }
        }
        .onAppear {
            self.viewModel.getData()
            self.viewModel.getDaily()
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
