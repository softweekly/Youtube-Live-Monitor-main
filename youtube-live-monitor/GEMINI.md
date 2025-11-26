# Project Overview

This is a Chrome extension that monitors a prioritized list of YouTube channels for live streams. When a channel goes live, the extension can automatically open the stream in a new tab and, optionally, send a command to Open Broadcaster Software (OBS) to start streaming or recording.

The extension uses a background script to periodically check for live streams and an options page to configure the monitored channels and OBS settings.

## Key Technologies

*   **Platform:** Chrome Extension (Manifest V3)
*   **Languages:** JavaScript
*   **Key APIs:**
    *   `chrome.storage`: To store user settings.
    *   `chrome.alarms`: To schedule periodic checks for live streams.
    *   `chrome.tabs`: To open and manage YouTube tabs.
    *   `WebSocket`: To communicate with OBS.

## Architecture

*   `background.js`: The service worker that contains the core logic for monitoring channels and interacting with OBS.
*   `options.html` / `options.js`: The user interface for configuring the extension.
*   `manifest.json`: The extension's manifest file, which defines its permissions, background script, and other properties.

# Building and Running

This is a Chrome extension, so there is no traditional build process. To run the extension, follow these steps:

1.  Open Chrome and navigate to `chrome://extensions`.
2.  Enable "Developer mode" in the top right corner.
3.  Click "Load unpacked" and select the `Youtube-Live-Monitor-main` directory.

The extension's options page can be accessed by clicking its icon in the Chrome toolbar.

# Development Conventions

## Code Style

The code follows standard JavaScript conventions. There is no explicit linter or formatter configured, but the existing code is well-formatted and readable.

## Testing

There are no automated tests in this project. Testing appears to be done manually by loading the extension in Chrome and observing its behavior.

## Contribution Guidelines

There are no explicit contribution guidelines.
