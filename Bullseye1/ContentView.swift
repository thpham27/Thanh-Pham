//
//  ContentView.swift
//  Bullseye1
//
//  Created by Thanh Pham on 8/23/20.
//  Copyright © 2020 Thanh Pham. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    //Properties
    //=========
    
    // Colors
    let midnightBlue = Color(red: 0,
                             green: 0.2,
                             blue: 0.4)
    // Game starts
    @State var score = 0
    @State var round = 1
    
    //User interface views
    @State var alertIsVisible = false
    @State var sliderValue = 50.0
    @State var target = Int.random(in: 1...100)
    var sliderValueRounded: Int {
    Int (sliderValue.rounded())
    }
    var sliderTargetDifference: Int {
        abs(sliderValueRounded - target)
    }
    
    //User interface content and layout
    var body: some View {
        NavigationView {
                VStack {
                    Spacer().navigationBarTitle("🎯 Bullseye 🎯")
                    
                    //Target row
                    HStack {
                        Text("Put the bullseye as close as you can to:").modifier(LabelStyle())
                        Text("\(target)").modifier(ValueStyle())
                    }
                    
                    
                    Spacer()
                    
                    //Slider row
                    HStack {
                        Text("1").modifier(LabelStyle())
                        Slider(value: $sliderValue, in: 1...100)
                            .accentColor(Color.green)
                            .animation(.easeOut)
                        Text("100").modifier(LabelStyle())
                    }
                    
                    Spacer()
                    
                    //Button row
                    Button(action: {
                        print("Points awarded: \(self.pointsForCurrentRound())")
                        self.alertIsVisible = true
                    }) {
                        Text("Hit me!").modifier(ButtonLargeTextStyle())
                    }
                .background(Image("Button")
                .modifier(Shadow()))
                    .alert(isPresented: $alertIsVisible) {
                        Alert(title: Text(alertTitle()),
                              message: Text(scoringMessage()),
                              dismissButton: .default(Text("Awesome!")) {
                                self.startNewRound()
                        })
                    }
                    
                    Spacer()
                    
                    //Score row
                    HStack {
                        Button(action: {
                            self.startNewGame()
                        }) {
                            HStack {
                                Image("StartOverIcon")
                            Text("Start over").modifier(ButtonSmallTextStyle())
                            }
                        }
                        .background(Image("Button"))
                        .modifier(Shadow())

                        Spacer()
                        Text("Score:").modifier(LabelStyle())
                        Text("\(self.score)").modifier(ValueStyle())
                        Spacer()
                        Text("Round:").modifier(LabelStyle())
                        Text("\(self.round)").modifier(ValueStyle())
                        Spacer()
                        NavigationLink(destination: AboutView()) {
                            HStack {
                                Image("InfoIcon")
                                Text("Info").modifier(ButtonSmallTextStyle())
                            }
                        }
                    .background(Image("Button")
                    .modifier(Shadow()))
                    }
                    .padding(.bottom, 20)
                .accentColor(midnightBlue)
                }
                .onAppear() {
                    self.startNewGame()
                }
            .background(Image("Background"))
    }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    


            //Methods
            //=======
    func pointsForCurrentRound() -> Int {
        let maxiumScore = 100
        let points: Int
        if sliderTargetDifference == 0 {
            points = 200
        } else  if  sliderTargetDifference == 1 {
            points = 150
        } else {
            points = maxiumScore - sliderTargetDifference
        }
        return points
    }
    func scoringMessage() -> String {
        return "The slider's value is \(sliderValueRounded).\n" + "The target value is \(self.target).\n" + "You scored \(pointsForCurrentRound()) points this round."
    }
    func alertTitle() -> String {
        let title: String
        if sliderTargetDifference == 0 {
            title = "Perfect!"
        } else if sliderTargetDifference < 5 {
            title = "You almost had it!"
        } else if sliderTargetDifference <= 10 {
            title = "Not bad."
        } else {
            title = "Are you even trying?"
        }
        return title
    }
    func startNewGame() {
        self.score = 0
        self.round = 1
        self.resetSlideAndTarget()
    }
    func startNewRound() {
        self.score = score + pointsForCurrentRound()
        self.round = round + 1
        self.resetSlideAndTarget()
    }
    func resetSlideAndTarget() {
        sliderValue = Double.random(in: 1...100)
        target = Int.random(in: 1...100)
    }
    
            // View modifiers
            // ==============
    
    struct LabelStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(Font.custom("Arial Rounded MT Bold", size: 18))
                .foregroundColor(Color.white)
                .shadow(color: Color.black, radius: 5, x: 2, y: 2)
        }
    }
    struct ValueStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(Font.custom("Arial Rounded MT Bold", size: 24))
                .foregroundColor(Color.yellow)
            .modifier(Shadow())
        }
    }
        
    struct Shadow: ViewModifier {
        func body(content: Content) -> some View {
            content
                .shadow(color: Color.black, radius: 5, x: 2, y: 2)
            }
        }
    struct ButtonLargeTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(Font.custom("Arial Rounded MT Bold", size: 18))
                .foregroundColor(Color.black)
            }
        }
    struct ButtonSmallTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(Font.custom("Arial Round MT Bold", size: 12))
                .foregroundColor(Color.black)
            }
        }
}

            // Preview
            // ======
        

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





