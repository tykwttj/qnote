# Qnote - Requirements Document

## Overview
Qnote (Quick + Note) is a beautiful, fast memo app with color-tag organization.
Built with Flutter for iOS and Android. Revenue model: free with ads + $2.99 Pro (ad-free).

## Target Users
Global general users (students, professionals, homemakers) across all ages.

## Core Features (MVP - Phase 1)

### P0 - Must Have
| Feature | Description |
|---------|-------------|
| Text Memo CRUD | Create, read, update, delete memos |
| Color Categories | 9 colors (white, red, orange, yellow, green, teal, blue, purple, pink) |
| Real-time Search | Incremental search across title + body |
| Home Screen Widget | 3 sizes (small/medium/large) for iOS and Android |
| Auto-save | 1-second debounce after input stops |
| AdMob Ads | Banner (320x50) + interstitial (every 3rd return, 90s min interval) |

### P1 - Required (Week 3-4)
| Feature | Description |
|---------|-------------|
| Pin/Favorite | Pin important memos to top |
| Sort/Filter | By date, color, title |
| Dark Mode | System-linked + manual toggle |
| Trash/Restore | 30-day retention, auto-purge |

### P2 - Recommended (Week 5-6)
| Feature | Description |
|---------|-------------|
| Share/Export | Text sharing, clipboard copy |
| Checklist | Todo-list style memos |
| List/Grid Toggle | Switch display modes |
| Localization | English + Japanese (8 more languages later) |

## Screens

### 1. Home Screen (Memo List)
- AppBar: hamburger menu, "Qnote" title, search icon, overflow menu
- Color filter bar (horizontal scroll): All + 9 colors
- Pinned memos section (top)
- Regular memos section (sorted by updatedAt desc)
- Swipe left: delete (move to trash)
- Swipe right: toggle pin
- Long press: context menu
- Banner ad at bottom
- FAB: create new memo

### 2. Memo Editor
- AppBar: back, "Edit" title, pin button, color picker button, overflow menu
- Title field (large font, max 100 chars)
- Metadata row: date + character count
- Body field (unlimited, auto-save on 1s debounce)
- Color picker: bottom sheet with 9-color grid
- Banner ad at bottom (hidden when keyboard is visible)

### 3. Search Screen
- Auto-focus text input in AppBar
- 300ms debounce real-time search
- Highlight matching text
- Recent search history (max 5)

### 4. Settings Screen
- Theme: Light / Dark / System
- Default color: initial memo color
- Font size: Small (14) / Medium (16) / Large (18)
- View mode: List / Grid
- Trash (navigate to sub-screen)
- Remove ads (Pro purchase)
- Language selection
- Rate app
- Version info

### 5. Trash Screen
- Deleted memos list (deletion date + remaining days)
- Per-memo: Restore / Permanently Delete
- Empty All button (with confirmation dialog)

## Data Model

### Memo
| Field | Type | Description |
|-------|------|-------------|
| id | String (UUID v4) | Primary key |
| title | String | Max 100 characters |
| body | String | Unlimited |
| color | MemoColor (enum) | 9 colors |
| isPinned | bool | Pin state |
| isDeleted | bool | Soft delete flag |
| createdAt | DateTime | Creation timestamp |
| updatedAt | DateTime | Last update timestamp |
| deletedAt | DateTime? | Trash move timestamp |

### Settings
| Field | Type | Default |
|-------|------|---------|
| themeMode | ThemeMode | system |
| defaultColor | MemoColor | white |
| fontSize | FontSize | medium (16) |
| viewMode | ViewMode | list |
| autoSave | bool | true |
| trashRetentionDays | int | 30 |
| locale | String | en |
| isPro | bool | false |

## Ad Rules
1. Home screen bottom: banner (320x50), always visible
2. Editor bottom: banner (320x50), hidden when keyboard is visible
3. Return to home: interstitial, every 3rd return, min 90s interval
4. First 3 memos: no ads (let user experience value first)
5. Never show interstitial when opening a memo

## Technical Stack
- Framework: Flutter 3.x
- State management: Riverpod
- Local DB: Drift (SQLite)
- Ads: google_mobile_ads (AdMob)
- Widgets: home_widget
- Analytics: Firebase Analytics + Crashlytics
- Localization: flutter_localizations + intl
- CI/CD: GitHub Actions + Fastlane

## Competitive Advantages
1. **Design**: Modern UI + animations vs ColorNote's dated interface
2. **Color Categories**: 9-color one-tap classification + color filter bar
3. **Widget Experience**: 3-size home screen widgets for glanceable access
