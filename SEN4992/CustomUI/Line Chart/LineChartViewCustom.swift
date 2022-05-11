//
//  LineCard.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 20.04.2022.
//

import SwiftUI

public struct LineChartViewCustom: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var data: ChartData
    public var title: String
    public var legend: String?
    public var style: ChartStyle
    public var darkModeStyle: ChartStyle

    public var formSize: CGSize
    public var dropShadow: Bool
    public var valueSpecifier: String

    @State private var touchLocation: CGPoint = .zero
    @State private var showIndicatorDot: Bool = false
    @State private var currentValue: Double = 2 {
        didSet {
            if oldValue != self.currentValue && showIndicatorDot {
                HapticFeedback.playSelection()
            }

        }
    }
    var frame = CGSize(width: 400, height: 400)

    private var rateValue: Int?

    public init(data: [Double],
                title: String,
                legend: String? = nil,
                style: ChartStyle = Styles.lineChartStyleOne,
                form: CGSize? = ChartForm.large,
                rateValue: Int? = 14,
                dropShadow: Bool? = true,
                valueSpecifier: String? = "%.1f") {

        var mockdata = data
        mockdata.append(data[data.count-1])
        self.data = ChartData(points: mockdata )
        self.title = title
        self.legend = legend
        self.style = style
        self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.lineViewDarkMode
        self.formSize = form!
        frame = CGSize(width: self.formSize.width, height: self.formSize.height/2)
        self.dropShadow = dropShadow!
        self.valueSpecifier = valueSpecifier!
        self.rateValue = rateValue
    }

    public var body: some View {
        ZStack(alignment: .center) {
            VStack(alignment: .leading) {
                if !self.showIndicatorDot {
                    
                    nonIndicatorTitleView
                    
                } else {
                    HStack {
                        Spacer()
                        VStack {
                            Text("\(self.currentValue, specifier: self.valueSpecifier) kg Co2")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        Spacer()
                    }
                    .padding(.top)
                    .transition(.scale)
                }
                GeometryReader { geometry in
                    Line(data: self.data,
                         frame: .constant(geometry.frame(in: .local)),
                         touchLocation: self.$touchLocation,
                         showIndicator: self.$showIndicatorDot,
                         minDataValue: .constant(nil),
                         maxDataValue: .constant(nil)
                    )
                }
                // X AXIS

                HStack {
                    Text("last week")
                    Spacer()
                    Text("yesteray")
                    Spacer()
                    Text("today")
                }
                .font(.system(size: 12))
                .foregroundColor(.gray)
            }
            .padding()
            .background(
                Color(uiColor: .secondarySystemGroupedBackground)
            )
            .cornerRadius(20)
            .shadow(color: self.style.dropShadowColor, radius: self.dropShadow ? 5 : 0)
        }
        .gesture(DragGesture()
        .onChanged({ value in
            self.touchLocation = value.location
            self.showIndicatorDot = true
            self.getClosestDataPoint(toPoint: value.location, width: self.frame.width, height: self.frame.height)
        })
            .onEnded({ _ in
                self.showIndicatorDot = false
            })
        )
    }
    
    
    private var nonIndicatorTitleView : some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(self.title)
                .font(.title)
                .bold()
                .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.textColor : self.style.textColor)
            if self.legend != nil {
                Text(self.legend!)
                    .font(.callout)
                    .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.legendTextColor :self.style.legendTextColor)
            }
            HStack {

                if self.rateValue ?? 0 != 0 {
                    if (self.rateValue ?? 0 >= 0){
                        Image(systemName: "arrow.up")
                    }else{
                        Image(systemName: "arrow.down")
                    }
                    Text("\(self.rateValue!) kg CO2 today").font(.system(.callout)).foregroundColor(.gray)
                }
            }
        }
        .transition(.opacity)
        .animation(.easeIn(duration: 0.1), value: customAnimationDuration)
        .padding([.leading, .top])
    }
    
    
    
    

    @discardableResult func getClosestDataPoint(toPoint: CGPoint, width: CGFloat, height: CGFloat) -> CGPoint {
        let points = self.data.onlyPoints()
        let stepWidth: CGFloat = width / CGFloat(points.count-1)
        let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)

        let index: Int = Int(round((toPoint.x)/stepWidth))
        if index >= 0 && index < points.count {
            self.currentValue = points[index]
            return CGPoint(x: CGFloat(index)*stepWidth, y: CGFloat(points[index])*stepHeight)
        }
        return .zero
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineChartViewCustom(data: [8, 23, 54, 32, 12, 37, 7, 23, 43], title: "Line chart",legend: "Basic", form: ChartForm.large)
                .preferredColorScheme(.dark)
//                .environment(\.colorScheme, .light)

            LineChartViewCustom(data: [282.502, 284.495, 283.51, 285.019, 285.197, 286.118, 288.737, 288.455, 289.391, 287.691, 285.878, 286.46, 286.252, 284.652, 284.129, 284.188], title: "Line chart", legend: "Basic")
//            .environment(\.colorScheme, .light)
        }
        .previewLayout(.sizeThatFits)
    }
}