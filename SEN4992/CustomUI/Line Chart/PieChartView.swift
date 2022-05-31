//
//  PieChartView.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 20.04.2022.
//

import SwiftUI

public struct PieChartView : View {
    public var data: [Double]
    public var title: String
    public var legend: String?
    public var style: ChartStyle
    public var formSize:CGSize
    public var dropShadow: Bool
    public var valueSpecifier:String
    
    
    public var labels: [String]
    public var colors: [String: Color] = ["Food": Color(hexString: "F2B705"), "Transport": Color(hexString: "025E73"), "Clothes": Color(hexString: "037F8C"), "Home": Color(hexString: "F2762E")]
    
    
    
    
    @State private var showValue = false
    @State private var currentValue: Double = 0 {
        didSet{
            if(oldValue != self.currentValue && self.showValue) {
                HapticFeedback.playSelection()
            }
        }
    }
    @State private var currentLabel: String = ""
    
    public init(labels: [String],data: [Double], title: String, legend: String? = nil, style: ChartStyle = Styles.pieChartStyleOne, form: CGSize? = ChartForm.medium, dropShadow: Bool? = true, valueSpecifier: String? = "%.1f"){
        self.labels = labels
        self.data = data
        self.title = title
        self.legend = legend
        self.style = style
        self.formSize = form!
        if self.formSize == ChartForm.large {
            self.formSize = ChartForm.extraLarge
        }
        self.dropShadow = dropShadow!
        self.valueSpecifier = valueSpecifier!
    }
    
    public var body: some View {
        
        VStack(alignment: .leading){
            HStack{
                if(!showValue){
                    Text(self.title)
                        .font(.headline)
                        .foregroundColor(style.textColor)
                }else{
                    Text("\(self.currentValue, specifier: self.valueSpecifier)")
                        .font(.headline)
                        .foregroundColor(style.textColor)
                }
                Spacer()
                Image(systemName: "chart.pie.fill")
                    .imageScale(.large)
                    .foregroundColor(style.legendTextColor)
            }

            HStack {
                PieChartRow(data: data, backgroundColor: style.backgroundColor, accentColor: self.style.accentColor, colors: colors, labels: labels, showValue: $showValue, currentValue: $currentValue, currentLabel: $currentLabel)
                    .foregroundColor(self.style.accentColor)
                //                        .padding(self.legend != nil ? 0 : 12)
                //                        .offset(y:self.legend != nil ? 0 : -10)
                
                VStack(alignment: .leading) {
                    ForEach((0..<data.count), id: \.self) {
                        let i = $0
                        let size: CGFloat = 5
                        if data[i] > 0 {
                            HStack {
                                Circle()
                                    .foregroundColor(colors[labels[i]])
                                    .frame(width: size, height: size)
                                Text("\(labels[i]) (\(Int(round(data[i] / data.reduce(0, +) * 100)))%)")
                                    .font(Font.footnote)
                                    .foregroundColor(style.legendTextColor)
                            }
                        }
                    }
                }
                Spacer()
                //.padding()
            }
            if(self.legend != nil) {
                Text(self.legend!)
                    .font(.headline)
                    .foregroundColor(self.style.legendTextColor)
                    .padding()
            }
            
        }
        .padding()
        .background(
            style.backgroundColor
//            Color(uiColor: .secondarySystemGroupedBackground)
        )
        .cornerRadius(20)
        .shadow(color: self.style.dropShadowColor, radius: self.dropShadow ? 4 : 0)
//        .padding()
        
        //        .frame(width: self.formSize.width, height: self.formSize.height)
    }
}

#if DEBUG
struct PieChartView_Previews : PreviewProvider {
    static var previews: some View {
        PieChartView(labels: ["Home", "Food", "Clothes", "Transport"], data:[56,78,53,65], title: "Title", legend: "Legend")
            .preferredColorScheme(.dark)
    }
}
#endif
