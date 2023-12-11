//
//  ContentView.swift
//  MathGameApp
//
//  Created by Zack Klopukh on 12/4/23.
//

import SwiftUI
import AVFoundation

// Content View in this app contains the main menu
struct ContentView: View {
    //Toggle views
    @State private var showOrganizedView = false
    @State private var showOptionsView = false
    @State private var ShowHowToPlayView = false
    @State private var showFinalScore = false
    
    //Important variables I like to have across views
    @State private var goodScore = 0
    @State private var counter: Double = 0
    @State private var questionNum = 1
    @State private var difficulty = 1
    //operators is a [Bool] where each index 0...3 represents addition, sub, mult, div, respectfully
    @State private var operators = [true, false, false, false]

    var body: some View {
        NavigationView {
            VStack {
                // The way my buttons worked, I made use of if statements to toggle which view your in as opposed to NavigationView because it was giving me too much trouble
                if showOrganizedView {
                    OrganizedView(
                        showOrganizedView: $showOrganizedView,
                        showFinalScore: $showFinalScore,
                        goodScore: $goodScore,
                        counter: $counter,
                        questionNum: $questionNum,
                        difficulty: $difficulty,
                        operators: $operators)
                } else if showOptionsView {
                    OptionsView(selectedDifficulty: $difficulty, selectedOperators: $operators) { returnedDifficulty, returnedOperators in
                            self.difficulty = returnedDifficulty
                            self.operators = returnedOperators
                            self.showOptionsView = false
                    }
                } else if ShowHowToPlayView {
                    HowToPlayView()
                } else {
                    //Main screen elements
                    Text("Quick Operations")
                        .font(Font.system(size: 50, weight: .bold, design: .rounded))
                            .foregroundColor(Color.orange)
                            .frame(width: 300, height: 120)
                            .multilineTextAlignment(.center)
                    Image("operatorsNice")
                        .resizable()
                        .frame(width: 180, height: 180)
                    
                    //The three buttons on main menu
                    AnswerBox(text: "Start", action: {
                        showOrganizedView = true
                    }, height: 170, width: 300)
                    AnswerBox(text: "Options", action: {
                        showOptionsView = true
                    }, height: 80, width: 300)
                    AnswerBox(text: "How To Play", action: {
                        ShowHowToPlayView = true
                    }, height: 80, width: 300)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// In the options menu you may change difficulty and operators, which are then saved for when you enter a game
struct OptionsView: View {
    @State private var goHome = false
    @Binding var selectedDifficulty: Int
    @Binding var selectedOperators: [Bool]
    
    //this return action allows us to return the needed info gathered on this inner view back to content view
    var returnAction: (Int, [Bool]) -> Void

    var body: some View {
        VStack {
            // Difficulty Picker
            Picker("Difficulty", selection: $selectedDifficulty) {
                Text("Easy").tag(1)
                Text("Medium").tag(2)
                Text("Hard").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // Separator
            Divider()
                .padding([.leading, .trailing], 16)

            // Select Operators Header
            Text("Select Operators")
                .font(.headline)
                .padding(.top, 8)

            // Operator List
            List {
                Toggle("Addition", isOn: Binding(
                    get: { selectedOperators[0] },
                    set: { selectedOperators[0] = $0 }
                ))
                .font(.headline)

                Toggle("Subtraction", isOn: Binding(
                    get: { selectedOperators[1] },
                    set: { selectedOperators[1] = $0 }
                ))
                .font(.headline)

                Toggle("Multiplication", isOn: Binding(
                    get: { selectedOperators[2] },
                    set: { selectedOperators[2] = $0 }
                ))
                .font(.headline)

                Toggle("Division", isOn: Binding(
                    get: { selectedOperators[3] },
                    set: { selectedOperators[3] = $0 }
                ))
                .font(.headline)
            }
            .frame(width: 375, height: 250)
            .listStyle(GroupedListStyle())

            //Return box that interacts with navigationLink
            AnswerBox(text: "Return", action: {
                returnAction(selectedDifficulty, selectedOperators)
                print("\(selectedOperators)")
            }, height: 150, width: 350)
            .padding()
        }
        .navigationBarTitle("Options", displayMode: .inline)
        .navigationBarBackButtonHidden(true)

        NavigationLink(destination: ContentView(), isActive: $goHome) {
            EmptyView()
        }
        .hidden()
    }
}




//Simple view containing a short introduction to the game
struct HowToPlayView: View {
    @State var goHome = false
    
    var body: some View {
        Image("operatorsNice")
            .resizable()
            .frame(width: 180, height: 180)
        Text("Quick Operations is a witty math game to test you skills and speed. There are 10 questions per round and 4 possible answer selections. In setting you may add any of the four basic operators as well as  change the difficulty. Try to imporve your speed while mainting good scores. Good Luck.")
            .font(Font.system(size: 20, weight: .bold, design: .rounded))
            .frame(width: 350)
        NavigationLink(destination: ContentView(), isActive: $goHome) {
            EmptyView()
        }
        .hidden()
            AnswerBox(text: "Return", action: {
                goHome = true
            }, height: 150, width: 350)
    }
}


//I made this to help break apart the gameplay from the countdown
struct OrganizedView: View {
    @Binding var showOrganizedView: Bool
    @Binding var showFinalScore: Bool
    @Binding var goodScore: Int
    @Binding var counter: Double
    @Binding var questionNum: Int
    @Binding var difficulty: Int
    @Binding var operators: [Bool]
    @State private var showCountdown = true
    
    var body: some View {
        if showCountdown {
            CountdownView {
                self.showCountdown = false
                showFinalScore = true
            }
        } else {
            GameScreen(showFinalScore: $showFinalScore, goodScore: $goodScore, counter: $counter, difficulty: $difficulty, operators: $operators)
        }
    }
}

//This is the main in game screen, it adds to the view the question number and time
struct GameScreen: View {
    @Binding var showFinalScore: Bool
    @Binding var goodScore: Int
    @Binding var counter: Double
    @Binding var difficulty: Int
    @Binding var operators: [Bool]
    @State private var timer: Timer?
    @State private var questionNum = 1
    
    var formattedCounter: String {
        return String(format: "%.2f", counter)
    }

    var body: some View {
        if (questionNum < 11) {
            //question number
            Text("\(questionNum).")
                .font(Font.system(size: 100, weight: .bold, design: .rounded))

            //present questions gives the prompt and options
            PresentQuestion(goodScore: $goodScore, questionNum: $questionNum, difficulty: $difficulty, operators: $operators)
                .onAppear {
                    timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                        counter += 0.01
                    }
                }
            //time elapsed
            Text("Time Elapsed: \(formattedCounter) s")
                .font(Font.system(size: 50, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
        } else {
            FinalScore(showFinalScore: $showFinalScore, goodScore: goodScore, counter: counter)
                .onAppear {
                    timer?.invalidate()
                }
        }
    }
}

//The final score is another view showing correct answers and time
struct FinalScore: View {
    @Binding var showFinalScore: Bool
    var goodScore: Int
    var counter: Double
    @State var negative = false

    var formattedTime: String {
        return String(format: "%.2f", counter)
    }

    var body: some View {
        VStack {
            Text("Final Score:")
                .font(.system(size: 30, weight: .bold, design: .rounded))
            Text("\(goodScore)/10")
                .font(.system(size: 50, weight: .bold, design: .rounded))
            Text("Time: \(formattedTime) s")
                .font(.system(size: 30, weight: .bold, design: .rounded))
            
            // Move the NavigationLink inside a conditional statement
            if negative {
                NavigationLink("Return", destination: ContentView(), isActive: $showFinalScore)
                    // Set an empty view to ensure that NavigationLink is not visible
                    .hidden()
            }
            
            AnswerBox(text: "Return", action: {
                negative = true
            }, height: 200, width: 200)
        }
    }
}


//This is what adds to the view the 4 possible question buttons and the prompt
struct PresentQuestion: View {
    
    @Binding var goodScore: Int
    @Binding var questionNum: Int
    @Binding var difficulty: Int
    @Binding var operators: [Bool]
    var player: AVAudioPlayer?
    
    var game: Game {
        Game(difficulty: difficulty, operations: operators)
    }
    
    var body: some View {

        let (possibleAnswers, correctIndex, prompt) = game.CreateQuestion()
        
        Text(prompt)
            .font(.system(size: 50, weight: .bold, design: .rounded))

        //HStack with two VStacks creates a 2x2 Matrix
        HStack{
            VStack {
                AnswerBox(text: "\(possibleAnswers[0])", action: {
                    if (correctIndex == 0) {
                        correctAnswer()
                    } else {
                        wrongAnswer()
                    }
                    
                }, height: 150, width: 150)
                AnswerBox(text: "\(possibleAnswers[1])", action: {
                    print("here1")
                    if (correctIndex == 1) {
                        correctAnswer()
                        print("\(goodScore)")
                    } else {
                        wrongAnswer()
                    }
                    
                }, height: 150, width: 150)
            }
            VStack {
                AnswerBox(text: "\(possibleAnswers[2])", action: {
                    print("here1")
                    if (correctIndex == 2) {
                        correctAnswer()
                        print("\(goodScore)")
                    } else {
                        wrongAnswer()
                    }
                    
                }, height: 150, width: 150)
                AnswerBox(text: "\(possibleAnswers[3])", action: {
                    print("here1")
                    if (correctIndex == 3) {
                        correctAnswer()
                        print("\(goodScore)")
                    } else {
                        wrongAnswer()
                    }
                    
                }, height: 150, width: 150)
            }
        }
    }
    
    private func correctAnswer() {
        questionNum += 1
        goodScore += 1
        playSound("correctAnswer.mp3")
    }

    private func wrongAnswer() {
        questionNum += 1
        playSound("wrongAnswer.mp3")
        
    }
    
    //In theory, this should be playing sound. The files I dragged into my XCode I can't hear which has nothing to do with my code, so i'm unsure if this works or not
    private func playSound(_ fileName: String) {
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
                return
            }

            do {
                try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)

                let player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                player.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    
}

//This view countsdown from 3
struct CountdownView: View {
    let onCountdownComplete: () -> Void
    @State private var countdown = 3

    var body: some View {
        VStack {
            Text("\(countdown)")
                .font(.system(size: 400, weight: .bold, design: .rounded))
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                        if countdown > 1 {
                            countdown -= 1
                        } else {
                            timer.invalidate()
                            onCountdownComplete()
                        }
                    }
                }
        }
    }
}


//I use this everywhere in the app to make nice consistent happy buttons
struct AnswerBox: View {
    
    let text: String
    let action: () -> Void
    let height: CGFloat
    let width: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CGFloat(18))
                .fill(.orange.opacity(0.35))
                .frame(width: width, height: height)
            
            RoundedRectangle(cornerRadius: CGFloat(20))
                .stroke(style: StrokeStyle(lineWidth: 7))
                .frame(width: width, height: height)
                .foregroundColor(.orange)
            
                .padding()
            Button(action: {action()}){
                Text(text)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .frame(width: width, height: height)
            }
        }
    }
}

#Preview {
    ContentView()
}
