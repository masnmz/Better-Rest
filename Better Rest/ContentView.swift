//
//  ContentView.swift
//  Better Rest
//
//  Created by Mehmet Alp Sönmez on 24/05/2024.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? .now
    }
    var body: some View {
        NavigationStack {
            Form {
                VStack(alignment: .leading, spacing: 10) {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker("PLease Enter a time", selection: $wakeUp, displayedComponents:
                            .hourAndMinute)
                    .labelsHidden()
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 0...20)
                }
                
            }
            .scrollContentBackground(.hidden)
            .background(LinearGradient(colors: [.yellow, .black], startPoint: .topLeading, endPoint: .bottomTrailing))
            
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedTime)
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60 /* Convert hours to seconds*/
            let minutes = (components.minute ?? 0) * 60 /* Convert minutes to seconds*/
            
            let prediction = try model.prediction(wake: Double( hour + minutes), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Your Ideal Bed Time is: "
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        showingAlert = true
    }
    
}

#Preview {
    ContentView()
}
