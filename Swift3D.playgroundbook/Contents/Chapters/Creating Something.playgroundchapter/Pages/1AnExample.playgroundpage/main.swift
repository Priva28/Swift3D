/*:

### Now that you know the basics, you can have a go at creating something yourself.
# Here's an example.

I have used Stacks to bring multiple objects together, ViewPlane to bring in a SwiftUI view and multiple modifiers to move around and change how the objects look. When you press run my code you should see be able to place an AR weather widget into your world. In the future, when AR glasses are a thing, imagine having widgets in your real world! This is a great way to prototype things like that.
 
*/
import Swift3D
import SwiftUI

struct WeatherWidget: Object {
    var object: Object {
        // Y Stack containing the view and the cloud. See the cloud object below.
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
            // The cloud raindrops - three capsules rotated and with blue color.
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
            
            // The cloud itself - 3 differently sized spheres with different offsets.
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

// The SwiftUI view that will appear in 3D.
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

// The content view with ARScene3D to add the weather widget to the real world.
struct ContentView: View {
    var body: some View {
        ARScene3D(baseObject: WeatherWidget())
    }
}

//#-hidden-code
import PlaygroundSupport
PlaygroundPage.current.setLiveView(ContentView())
//#-end-hidden-code
