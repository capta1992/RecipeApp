#Recipe App for Fetch

This SwiftUI application displays a list of recipes from the provided endpoint. Features:

Displays each recipe's name, cuisine and photo.

Supports refresh at any time from the navigation bar.

Handles empty or malformed data gracefully, showing a user-friendly message

Uses async/await for all data fetching and image loading

Implements a disk-based image cahce to minimize repeated requests, and in-memory caching for performance

Below is a short screenshot of the main screen:


Focus Areas

Clean MVVM + Coordinator architecture:

The 'RecipesViewModel' handles state
'ImageCache' docuses on caching logic.
'RecipeService' handles JSON fetching
'RecipeCoodinator' sets up the SwiftUI view
Performance:

On-demand image loading only when rows appear
Disk + memeory caching to reduce bandwidth usage
Error Handling:

If data is malformed or the feed is empty, the UI shows specific states
Time Spent

I spent appoximately 6-8 hours on this project:

2-3 hours designing architecture (MVVM + C, caching approach)
2 hours implementing the data fetch & concurrency code
1 hour Building the SwiftUI, styling
** 2 hours** final polish & writing unit tests
Trade-offs & Decisions

No external libraries for caching to meet the challenge constraints. This meeant I had to build my own disk cache logic
Chose to keep the UI minimal yet clear, focusing on name, cuisine, and a small image.
Marked 'RecipesViewModel' as '@MainActor' to avoid concurrency issues with '@Published'. Also maked 'RecipeCoordinator' as '@MainActor' to fix cross actor init warnings
Weakest Part of the Project

The disk caching strategy uses a naive approach (hashing URL strings). In a real production app, I'd consider a more robust hashing or key management, plus a TTL or reaping strategy for old images
The UI is very minimal. I could of adding some animations or effects to make the UI pop or the youtube symbol etc. deciding to keep it simple for now focus on concurrency, testing, architecture, and caching logic
Additional Information

I included unit tests for data fetching(success, empty, malformed) and image caching (via a mock service)
If i had more time add more advanced UI design
