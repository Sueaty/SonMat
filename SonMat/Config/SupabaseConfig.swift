//
//  SupabaseConfig.swift
//  SonMat
//
//  Configuration constants for the Supabase backend.
//
//  HOW TO FILL THESE IN:
//  1. Go to app.supabase.com and select your project
//  2. Navigate to Settings → API
//  3. Copy "Project URL" and paste it as supabaseURL below
//  4. Copy the "anon public" key and paste it as supabaseAnonKey below
//
//  SECURITY NOTE:
//  The anon key is safe to ship in the app bundle — it is a publishable
//  key, not a secret. RLS policies (002_rls_policies.sql) prevent
//  viewers from writing or deleting data. Never put the service_role
//  key here.
//

import Foundation

enum SupabaseConfig {
    // Example: "https://xyzcompany.supabase.co"
    static let supabaseURL = "https://hhnnynrwtppntjwzyhyt.supabase.co"

    // Example: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    static let supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhobm55bnJ3dHBwbnRqd3p5aHl0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI4MTQ2MDQsImV4cCI6MjA4ODM5MDYwNH0.y-oM1gFnVgQseb6MTvtBhrlLbV271uamvzFI-xKLoR0"
}
