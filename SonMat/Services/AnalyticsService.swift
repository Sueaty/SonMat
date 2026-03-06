//
//  AnalyticsService.swift
//  SonMat
//

import FirebaseAnalytics

enum AnalyticsService {

    // MARK: - Screen

    static func logScreenView(screenName: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName
        ])
    }

    // MARK: - Recipe List

    static func logRecipeListLoaded(count: Int) {
        Analytics.logEvent("recipe_list_loaded", parameters: [
            "recipe_count": count
        ])
    }

    static func logSearchPerformed(query: String, resultCount: Int) {
        Analytics.logEvent("search_performed", parameters: [
            "query": query,
            "result_count": resultCount
        ])
    }

    static func logCategoryFilterTapped(category: String) {
        Analytics.logEvent("category_filter_tapped", parameters: [
            "category": category
        ])
    }

    // MARK: - Recipe Detail

    static func logRecipeViewed(recipeID: String, title: String, category: String) {
        Analytics.logEvent("recipe_viewed", parameters: [
            "recipe_id": recipeID,
            "title": title,
            "category": category
        ])
    }

    static func logScrollDepth(recipeID: String, depthPercent: Int) {
        Analytics.logEvent("recipe_scroll_depth", parameters: [
            "recipe_id": recipeID,
            "depth_percent": depthPercent
        ])
    }

    // MARK: - Session

    static func logSessionStart() {
        Analytics.logEvent("session_start", parameters: nil)
    }

    static func logSessionEnd() {
        Analytics.logEvent("session_end", parameters: nil)
    }
}
