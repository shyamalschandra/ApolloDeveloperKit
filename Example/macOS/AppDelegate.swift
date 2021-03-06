//
//  AppDelegate.swift
//  ApolloDeveloperKitExample-macOS
//
//  Created by Ryosuke Ito on 11/14/19.
//  Copyright © 2019 Ryosuke Ito. All rights reserved.
//

import Cocoa
import Apollo
#if DEBUG
import ApolloDeveloperKit
#endif

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private var apollo: ApolloClient!
    #if DEBUG
    private var server: ApolloDebugServer!
    #endif

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let url = URL(string: "http://localhost:8080/graphql")!
        #if DEBUG
        let networkTransport = DebuggableNetworkTransport(networkTransport: HTTPNetworkTransport(url: url))
        let cache = DebuggableNormalizedCache(cache: InMemoryNormalizedCache())
        let store = ApolloStore(cache: cache)
        server = ApolloDebugServer(networkTransport: networkTransport, cache: cache)
        server.enableConsoleRedirection = true
        try! server.start(port: 8081)
        #else
        let networkTransport = HTTPNetworkTransport(url: url)
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        #endif
        apollo = ApolloClient(networkTransport: networkTransport, store: store)
        apollo.cacheKeyForObject = { $0["id"] }
        let postListViewController = NSApplication.shared.windows.first!.contentViewController as! PostListViewController
        postListViewController.apollo = apollo
        postListViewController.serverURL = server.serverURL
        postListViewController.delegate = self
        postListViewController.loadData(completion: nil)
    }
}

extension AppDelegate: PostListViewControllerDelegate {
    func postListViewControllerWantsToToggleConsoleRedirection(_ postListViewController: PostListViewController) {
        server.enableConsoleRedirection = !server.enableConsoleRedirection
    }
}
