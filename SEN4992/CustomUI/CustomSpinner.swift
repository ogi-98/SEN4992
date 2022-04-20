//
//  CustomSpinner.swift
//  SEN4992
//
//  Created by Oğuz Kaya on 20.04.2022.
//

import SwiftUI

struct CustomSpinner: View {
    
    private let rotationTime: Double = 0.75
    private let animationTime: Double = 1.9
    private let fullRotation: Angle = .degrees(360)
    private static let initialDegree: Angle = .degrees(270)
    
    @State private var spinnerStart: CGFloat = 0.0
    @State private var spinnerEndS1: CGFloat = 0.03
    @State private var spinnerEndS2S3: CGFloat = 0.03
    
    
    @State private var rotationDegreeS1 = initialDegree
    @State private var rotationDegreeS2 = initialDegree
    @State private var rotationDegreeS3 = initialDegree
    @State var repeats = true
    
    var body: some View {
        ZStack {
            // S3
//            SpinnerCircle(start: spinnerStart, end: spinnerEndS2S3, rotation: rotationDegreeS3, color: .pink)
            
            // S2
//            SpinnerCircle(start: spinnerStart, end: spinnerEndS2S3, rotation: rotationDegreeS2, color: .green)
            
            // S1
            SpinnerCircle(start: spinnerStart, end: spinnerEndS1, rotation: rotationDegreeS1, color: Color(uiColor: .label))
        }
        .frame(width: 45, height: 45, alignment: .center)
        .padding(10)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .onAppear {
            self.animateSpinnerOnAppear()
            Timer.scheduledTimer(withTimeInterval: animationTime, repeats: repeats) { timer in
                self.animateSpinnerOnAppear()
            }
        }
    }
    
    // MARK: Animation methods
    func animateSpinner(with duration: Double, completion: @escaping (() -> Void)) {
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            withAnimation(Animation.easeInOut(duration: self.rotationTime)) {
                completion()
            }
        }
    }
    
    
    private func animateSpinnerOnAppear() {
        animateSpinner(with: rotationTime) { self.spinnerEndS1 = 1.0 }
        
        animateSpinner(with: (rotationTime * 2) - 0.025) {
            self.rotationDegreeS1 += fullRotation
            //            self.spinnerEndS2S3 = 0.8
        }
        
        animateSpinner(with: (rotationTime * 2)) {
            self.spinnerEndS1 = 0.03
            //            self.spinnerEndS2S3 = 0.03
        }
        
        animateSpinner(with: (rotationTime * 2) + 0.0525) { self.rotationDegreeS2 += fullRotation }
        
        animateSpinner(with: (rotationTime * 2) + 0.225) { self.rotationDegreeS3 += fullRotation }
    }
    
    
}

struct SpinnerCircle: View {
    var start: CGFloat? = 0.0
    var end: CGFloat? = 0.75
    var rotation: Angle? = .degrees(0.0)
    var color: Color? = Color(UIColor.label)
    
    var body: some View{
        Circle()
            .trim(from: start ?? 0.0, to: end ?? 0.0)
            .stroke(style: StrokeStyle(lineWidth: 1.0, lineCap: .round))
            .fill(color ?? .blue)
            .rotationEffect(rotation ?? .degrees(0.0))
    }
    
}

struct CustomSpinner_Previews: PreviewProvider {
    static var previews: some View {
        CustomSpinner()
            .preferredColorScheme(.light)
    }
}
