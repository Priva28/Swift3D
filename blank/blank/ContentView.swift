//
//  ContentView.swift
//  blank
//
//  Created by Christian Privitelli on 11/4/21.
//

import SwiftUI

struct obj: Object {
    @State3D var test = false
    
    var object: Object {
        return Stack(.y, spacing: 0) {
            Plane()
                .color(.blue)
            Stack(.x) {
                Box()
                    .color(test ? .red : .white)
                    .offset(x: test ? -1 : 0)
                    .opacity(test ? 1 : 0.5)
                    .animation(Animation3D.easeOut(duration: 5).repeatForever())
                Stack(.y) {
                    Box()
                        .color(.red)
                    Sphere()
                        .onAppear {
                            test.toggle()
                        }
                }
            }
        }
    }
}

struct obj2: Object {
    @State3D var test2 = false
    var attributes: ObjectAttributes = ObjectAttributes()
    var object: Object {
        Stack(.y) {
            Box()
            Sphere()
            Pyramid()
            Capsule()
            Cone()
            Cylinder()
            Torus()
            Tube()
        }
    }
}

struct obj3: Object {
    @State3D var test = 0
    var attributes: ObjectAttributes = ObjectAttributes()
    var object: Object {
        Box()
            .chamferRadius(0.1)
            .offset(x: test == 0 ? 0 : 1)
            .color(test == 0 ? .white : .red)
            .animation(.linear(duration: 3).repeatForever())
            .rotation(x: test == 0 ? 0 : 45)
            //.opacity(test == 0 ? 0.9 : 1)
            .onAppear {
                test = 3
            }
    }
}

struct TrulyCustomObject: Object {
    @State3D private var specialVariable: Bool = /*#-editable-code*/true/*#-end-editable-code*/
    
    var object: Object {
        ViewPlane(size: CGSize(width: 20, height: 30)) {
            VStack {
                Text("Hello my name is viewplane")
                Spacer()
            }
        }
        .color(.red)
        //Box(size: .init(width: <#T##CGFloat#>, height: <#T##CGFloat#>, length: <#T##CGFloat#>), chamferRadius: <#T##CGFloat#>)
    }
}

struct TwoDInThreeD: Object {
    var object: Object {
        ViewPlane(vertical: true) {
            //#-editable-code
            VStack {
                Text("This is a 2D SwiftUI view inside a 3D world!")
                    .font(.title)
                    .padding()
                Text("Try adding your own view here!")
            }
            //#-end-editable-code
        }
    }
}

struct ContentView: View {
    var body: some View {
        ARScene3D(baseObject: WeatherWidget(), realisticLighting: false)
    }
}

struct WeatherWidget: Object {
    var object: Object {
        Stack(.y) {
            ViewPlane(size: .init(width: 5.5, height: 7.5), vertical: false, body: WeatherView())
                .rotation(x: -80)
                .opacity(0.8)
            Cloud()
        }
        .offset(y: -5)
    }
}

struct Cloud: Object {
    var object: Object {
        Stack(.y) {
            Stack(.x, spacing: 0.3) {
                Capsule(capRadius: 0.1, height: 0.8)
                    .rotation(z: -40)
                    .color(.blue)
                Capsule(capRadius: 0.1, height: 0.9)
                    .rotation(z: -40)
                    .color(.blue)
                Capsule(capRadius: 0.1, height: 0.8)
                    .rotation(z: -40)
                    .color(.blue)
            }
            .offset(x: 1.1, y: 0.8)
            Stack(.x) {
                Sphere(radius: 0.6)
                    .offset(x: 1)
                    .opacity(0.8)
                Sphere(radius: 1)
                    .offset(x: -0.5, y: 0.35)
                    .opacity(0.95)
                Sphere(radius: 0.6)
                    .offset(x: -0.5)
                    .opacity(0.8)
            }
        }
        .offset(x: -2, y: -2)
    }
}

struct WeatherView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundColor(Color.gray.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.gray.opacity(0.8), lineWidth: 3)
                )
            
            VStack {
                weatherDay(day: "Monday")
                Divider()
                weatherDay(day: "Tuesday")
                Divider()
                weatherDay(day: "Wednesday")
                Divider()
                Group {
                    weatherDay(day: "Thursday")
                    Divider()
                    weatherDay(day: "Friday")
                    Divider()
                    weatherDay(day: "Saturday")
                    Divider()
                    weatherDay(day: "Sunday")
                }
            }
            .foregroundColor(.white)
            .padding()
        }
    }
    
    let randomWeather = ["cloud.drizzle.fill", "cloud.bolt.rain.fill", "cloud.sun.fill", "sun.max.fill", "cloud.rain.fill"]
    
    func weatherDay(day: String) -> some View {
        HStack {
            Text(day)
            Spacer()
            Image(systemName: randomWeather.randomElement()!)
                .resizable()
                .frame(width: 15, height: 15)
                .padding(.horizontal)
            Text("\(Int.random(in: 18...24))")
                .padding(.horizontal)
            Text("\(Int.random(in: 5...13))")
        }
        .padding(.vertical, 3)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ContentView2: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
            Image(uiImage: UIImage(named: "protocolDesign")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .edgesIgnoringSafeArea(.all)
    }
}
