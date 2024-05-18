//
//  ContentView.swift
//  Gesture
//
//  Created by Nabil Birgle on 04/05/2024.
//

import SwiftUI

struct ContentView: View {
	@State private var isDragging = false
	var drag: some Gesture {
		DragGesture()
			.onChanged(test)
			.onChanged { _ in self.isDragging = true }
			.onEnded { d in test(x: d) }
			.onEnded { _ in self.isDragging = false }
	}
	func test(x: DragGesture.Value) -> Void {
		let d: CGSize = x.translation
		delta = CGSize(
			width: Int(d.width*100/circle_width),
			height: -Int(d.height*100/circle_height)
		)
	}
	@State var circle_width: CGFloat = 0
	@State var circle_height: CGFloat = 0
	@State var delta: CGSize = CGSize.init(width: 0, height: 0)
	let circle = Circle()
	var body: some View {
			circle
				.fill(self.isDragging ? Color.red : Color.blue)
				.gesture(drag)
				.getSize{ size in
					circle_height = size.height
					circle_width = size.width
				}
//				.scaleEffect(magnifyBy)
				.gesture(magnification)
		Text("delta: \(delta)")
		Text("magnify: \(m)")
		Text("magnifyBy: \(magnifyBy)")
	}

	@GestureState private var magnifyBy = 1.0
	@State private var m = 1.0
	var magnification: some Gesture {
		MagnifyGesture()
			.onEnded({value in m = value.magnification})
			.updating($magnifyBy) { value, gestureState, transaction in
				gestureState = value.magnification
			}
	}
}










extension View {
	func getSize(size: @escaping (CGSize) -> Void) -> some View {
		background(
			GeometryReader { geometry in
				Color.clear
					.preference(key: ViewPreferenceKey.self, value: geometry.size)
			}
		)
		.onPreferenceChange(ViewPreferenceKey.self, perform: size)
	}
}

private struct ViewPreferenceKey: PreferenceKey {
	static var defaultValue: CGSize = .zero
	static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
	}
}

#Preview {
    ContentView()
}
