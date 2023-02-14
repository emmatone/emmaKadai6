//
//  ContentView.swift
//  emmaKadai6
//
//  Created by Emma on 2023/02/04.
//

import SwiftUI

//ヘッダー
struct KadaiHeaderView: View {
    let kadaiNo: String
    let kadaiTitle: String
    let kadaiTitleColor: Color
    let kadaiColor: Color

    var body: some View {
        Text(kadaiNo + "\n" + kadaiTitle)
            .font(.headline)
            .fixedSize(horizontal: false, vertical: true )
            .foregroundColor(kadaiTitleColor)
            .frame(maxWidth: .infinity)
            .padding()
            .background(kadaiColor)
    }
    init(_ kadaiNo: String, kadaiTitle: String, kadaiTitleColor: Color = Color.white, kadaiColor: Color = Color.primary){
        self.kadaiNo = kadaiNo
        self.kadaiTitle = kadaiTitle
        self.kadaiTitleColor = kadaiTitleColor
        self.kadaiColor = kadaiColor
    }
}

//アラート
struct AlertInfo {
    let alertTitle: String = "結果"
    let buttonLabel: String = "再挑戦"
    var isPressed: Bool = false
    var message: String = ""
}

class Model: ObservableObject {
    @Published var alertInfo = AlertInfo()
    @Published var defaultValue: Double = 50.0
    @Published var questionValue: Int = 0

    let minValue: Int = 1
    let maxValue: Int = 100

    func setQuestionValue() {
        questionValue = Int.random(in: minValue...maxValue)
    }

    func call() {
        if Int(defaultValue) == questionValue {
            alertInfo.message = "あたり!\nあなたの値: \(Int(defaultValue))"
        } else {
            alertInfo.message = "はずれ!\nあなたの値: \(Int(defaultValue))"
        }
        alertInfo.isPressed = true
    }
}

struct ContentView: View {
    // ヘッダーの定義
    let kadaiHeaderView = KadaiHeaderView(
        "課題6",
        kadaiTitle: "スライダーを指定された位置に移動させるゲームアプリ",
        kadaiColor: Color.pink
    )

    @StateObject var model = Model()

    var body: some View {
        VStack(spacing: 30) {
            //ヘッダー
            kadaiHeaderView

            //問題の値
            Text("\(model.questionValue)")
                .onAppear(perform: { model.setQuestionValue() })
                .font(.largeTitle)
                .padding(0)

//            //スライダーの値
//            Text("\(Int(model.defaultValue))")
//                .font(.title)
//                .foregroundColor(kadaiHeaderView.kadaiColor)

            //スライダー
            Slider(
                value: $model.defaultValue,
                in: Double(model.minValue)...Double(model.maxValue),
                step: 1,
                minimumValueLabel: Text(String(model.minValue)),
                maximumValueLabel: Text(String(model.maxValue)),
                label: {} // iOSでは使われない
            )
            .tint(kadaiHeaderView.kadaiColor)
            .padding(15)
            .background(
                Capsule()
                    .fill(kadaiHeaderView.kadaiColor)
                    .opacity(0.1)
            )
            .padding(.horizontal)

            //判定ボタンとアラート
            Button(action: { model.call() }){
                Text("判定する!")
                    .font(.title3)
                    .padding(16)
                    .foregroundColor(.white)
                    .background(kadaiHeaderView.kadaiColor)
                    .cornerRadius(30)
            }
            .alert(
                model.alertInfo.alertTitle,
                isPresented: $model.alertInfo.isPressed,
                presenting: model.alertInfo.message,
                actions: { _ in
                    Button( model.alertInfo.buttonLabel, action: { model.setQuestionValue() })
                },
                message: { message in
                    Text(message)
                }
            )
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
