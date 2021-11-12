//
//  ContentView.swift
//  BetterRest
//
//  Created by Abdelrahman  Desoki on 24/06/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State private var sleepAmount = 8.0
    @State private var coffeAmount = 1
    @State private var wakeUp = defaultwaketime

    @State private var alertTitle = ""
    @State private var alertmesage = ""
    @State private var showingAlert = false
    
    
    
    
var body: some View {
    NavigationView{
        Form{
                
            Section{
                Text("When do you want to wake up ?")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.green)
                    .padding(.all)
                    

                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
            }

            VStack(alignment: .leading, spacing: 0) {
                Text("Desired amount of sleep")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.green)
                    .padding(.all)
                
                Stepper(value: $sleepAmount, in: 4...12, step:0.25){
                    Text("\(sleepAmount, specifier: "%g") hours")
                    }
            }
            VStack(alignment: .leading, spacing: 0) {
                Text("Daily coffe intake")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.green)
                    .padding(.all)
                
                Picker("From", selection: $coffeAmount){
                    ForEach(1 ..< 21){
                        Text("\($0)")
                    }
                }
                    if coffeAmount == 1{
                        Text("1 Cup")
                    }
                    else {
                        Text("\(coffeAmount) cups")
                    }
            }
            }
            .navigationBarTitle("BetterRest")
            .navigationBarItems(trailing:
                Button(action: calculateBedtime ) {
                       Text("Calculate")
            } )
            .alert(isPresented: $showingAlert, content: {
                Alert(title:  Text(alertTitle), message: Text(alertmesage ), dismissButton: .default(Text("OK")))
            })
        }
    }
   static var defaultwaketime: Date{
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func calculateBedtime() {
        let model = sleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try
                model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            alertmesage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bed time is .."
            
            
        } catch {
            alertTitle = "ERror"
            alertmesage = "Sorry there was a problem calculating ur bed time !"
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
