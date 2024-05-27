//
//  ContentView.swift
//  Better Rest
//
//  Created by Mehmet Alp Sönmez on 24/05/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    @State private var coffeamount = 1
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker("PLease Enter a time", selection: $wakeUp, displayedComponents:
                        .hourAndMinute)
                        .labelsHidden()
                Text("Desired amount of sleep")
                    .font(.headline)
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                
                Text("Daily coffee intake")
                    .font(.headline)
                
                Stepper("\(coffeamount) cup(s)", value: $coffeamount, in: 1...20)
                
                
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedTime)
            }
        }
    }
    
    func calculateBedTime() {
        
    }
    
}

#Preview {
    ContentView()
}
