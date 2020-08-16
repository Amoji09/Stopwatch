//
//  ContentView.swift
//  Stopwatch
//
//  Created by Amogh Mantri on 8/16/20.
//  Copyright © 2020 Amogh Mantri. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    @State var minutes  = 0
    @State var seconds = 0
    @State var centiseconds = 0
    @State var running = false
    @State var lapTimes : [LapTime] = []
    @State var lapCount = 1
    @State var lapMinutes = 0
    @State var lapSeconds = 0
    @State var lapCentiseconds = 0
    
    var body: some View {
        VStack{
            Text(getTimeString(cS: self.centiseconds, sS: self.seconds, mS: self.minutes))
                .font(.system(size: 60, design: .monospaced))
                .frame(width: 300.0, height: 100.0)
                .onReceive(timer){_ in
                    if(self.running){
                        self.timerCalcs()
                    }
            }
            HStack{
                Button(action: {
                    if(!self.running){
                        self.minutes = 0
                        self.seconds = 0
                        self.centiseconds = 0
                        self.lapTimes = []
                        self.lapMinutes = 0
                        self.lapSeconds = 0
                        self.lapCentiseconds = 0
                        self.lapCount = 1
                    }
                    else{
                        
                        self.lapTimes.append(LapTime(n: self.lapCount, t: self.getTimeString(cS: self.lapCentiseconds, sS: self.lapSeconds, mS: self.lapMinutes)))
                        self.lapCount += 1
                        self.lapMinutes = 0
                        self.lapSeconds = 0
                        self.lapCentiseconds = 0
                    }
                }) {
                    ZStack{
                        Circle().fill(Color.gray).frame(width: 100, height: 100)
                        self.running ? Text("Lap").foregroundColor(Color.white).font(.system(size: 20, design: .monospaced)) : Text("Reset").foregroundColor(Color.white).font(.system(size: 20, design: .monospaced))
                    }
                }
                
                Spacer()
                Button(action: {
                    self.running = !self.running
                }) {
                    ZStack{
                        Circle().fill(self.running ? Color.red : Color.green).frame(width: 100, height: 100).font(.system(size: 20, design: .monospaced))
                        self.running ? Text("Stop").foregroundColor(Color.white).font(.system(size: 20, design: .monospaced)) : Text("Start").foregroundColor(Color.white).font(.system(size: 20, design: .monospaced))
                    }
                }
            }.padding()
            List{
                LapTime(n: self.lapCount, t: self.getTimeString(cS: self.lapCentiseconds, sS: self.lapSeconds, mS: self.lapMinutes))
                ForEach(self.lapTimes.reversed()) { time in
                    time
                }
            }
        }
        
    }
    
    func timerCalcs(){
        if(self.centiseconds < 99){
            self.centiseconds += 1
        }
        else{
            self.centiseconds = 0
            if(self.seconds < 59){
                self.seconds += 1
            }
            else{
                self.seconds = 0
                self.minutes += 1
            }
        }
        
        if(self.lapCentiseconds < 99){
            self.lapCentiseconds += 1
        }
        else{
            self.lapCentiseconds = 0
            if(self.lapSeconds < 59){
                self.lapSeconds += 1
            }
            else{
                self.lapSeconds = 0
                self.lapMinutes += 1
            }
        }
    }
    
    func getTimeString(cS: Int, sS : Int, mS: Int) -> String{
        var centiString = String(cS)
        var secString = String(sS)
        var minString = String(mS)
        if(cS<10){
            centiString = "0\(cS)"
        }
        if(sS<10){
            secString = "0\(sS)"
        }
        if(mS<10){
            minString = "0\(mS)"
        }
        return "\(minString):\(secString).\(centiString)"
    }
}

struct LapTime : View, Identifiable{
    let id = UUID()
    let num : Int
    let time : String
    
    var body : some View{
        HStack{
            Text("Lap \(num)").font(.system(size: 20, design: .monospaced))
            Spacer()
            Text(time).font(.system(size: 20, design: .monospaced))
        }
    }
    
    init(n : Int, t : String){
        num = n
        time = t
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
