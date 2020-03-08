//
//  DailyView.swift
//  COVID 19
//
//  Created by Andrey Yoshua Manik on 08/03/20.
//  Copyright © 2020 Brid. All rights reserved.
//

import SwiftUI

struct DailyView: View {
    let daily: DashboardDaily
    let lastDaily: DashboardDaily
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(daily.reportDateString.shortFormat)
                .fontWeight(.semibold)
            
            HStack {
                HStack {
                    Image(lastDaily.deltaConfirmed > daily.deltaConfirmed ? "downward" : "upward")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                    Text("Confirmed: \(daily.deltaConfirmed)")
                        .foregroundColor(DashboardEnum.infected.backgroundColor)
                        .fontWeight(.bold)
                }
                HStack {
                    Image((lastDaily.deltaRecovered ?? 0) > (daily.deltaRecovered ?? 0) ? "downward" : "upward")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                    Text("Recovered: \(daily.deltaRecovered ?? 0)")
                        .foregroundColor(DashboardEnum.recovered.backgroundColor)
                        .fontWeight(.bold)
                }
            }
            
            Text("Total \(daily.mainlandChina) cases in china and \(daily.otherLocations) on the other location")
        }
    }
}

struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        DailyView(
            daily: DashboardDaily(reportDate: 0, mainlandChina: 0, otherLocations: 0, totalConfirmed: 00, totalRecovered: 0, reportDateString: Date(), deltaConfirmed: 0, deltaRecovered: 0, objectid: 0),
            lastDaily: DashboardDaily(reportDate: 0, mainlandChina: 0, otherLocations: 0, totalConfirmed: 0, totalRecovered: 0, reportDateString: Date(), deltaConfirmed: 0, deltaRecovered: 0, objectid: 0))
    }
}
