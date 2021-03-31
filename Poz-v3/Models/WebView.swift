//
//  WebView.swift
//  Poz-v2
//
//  Created by Kish Parikh on 3/14/21.
//

import SwiftUI
import WebKit


struct WebView: UIViewRepresentable {
    
    @State var link: String

    func makeUIView(context: Context) -> WKWebView {
        WKWebView(frame: .zero)
    }

    func updateUIView(_ view: WKWebView, context: UIViewRepresentableContext<WebView>) {

        let request = URLRequest(url: URL(string: link)!)

        view.load(request)
    }
}
