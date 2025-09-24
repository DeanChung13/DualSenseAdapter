# DualSenseAdapter

一個輕量的 macOS 功能表列（Menu Bar）工具，用來監聽 PlayStation 5 DualSense 控制器，並可將按鍵動作轉換為鍵盤事件。以 AppKit 與 GameController 建置，方便你依需求快速自訂映射。

[English](README.md) | 繁體中文

## 功能特色
- 功能表列小圖示與選單
- 自動搜尋/連線 DualSense 控制器
- 在 Xcode 主控台輸出按鍵/軸值變化，方便除錯
- 從控制器觸發鍵盤事件（預設：Options → "i"）
- 支援背景監控，應用程式非前景時仍可接收控制器事件
- 單一檔案集中管理映射（`DualSenseManager.swift`）

## 系統需求
- macOS 11.5 (Big Sur) 以上
- Xcode 15 以上（Swift 5.9+）
- 一支 DualSense（PS5）控制器（藍牙或 USB）
- 輔助使用（Accessibility）權限（用於送出鍵盤事件）

## 快速開始
1. 下載或 Clone 專案。
2. 以 Xcode 開啟 `DualSenseAdapter.xcodeproj`。
3. 視需要設定簽章（Signing Team）。
4. Build & Run。

App 啟動後，你會在功能表列看到控制器圖示。按下控制器按鍵，Xcode 主控台會顯示對應的日誌。

## 連線 DualSense
- 系統設定 → 藍牙 → 配對你的 DualSense。
- 或是使用 USB-C 連接。

## 權限（輔助使用）
本 App 使用 `CGEvent` 送出模擬鍵盤事件，macOS 需要你允許輔助使用權限。

若未自動跳出提示：
1. 系統設定 → 隱私權與安全性 → 輔助使用。
2. 點選「+」加入已編譯的 App（或在列表中打開權限）。
3. 重新啟動 App 後再試。

未授權時，模擬鍵盤事件不會傳到其他 App。

## 運作方式
- `AppDelegate` 建立功能表列圖示並啟動 `GCController` 掃描。
- `DualSenseManager` 監聽控制器連線/斷線事件並設定各種輸入 Handler。
- 在各 Handler 中可記錄日誌，或呼叫 `simulateKeyPress(_:)` 送出鍵盤事件。

預設示範：Options 按鈕按下時送出字母 `i`：
```swift
if #available(iOS 14.0, macOS 11.0, tvOS 14.0, *) {
    gamepad.buttonOptions?.valueChangedHandler = { [weak self] button, value, pressed in
        print("Options \(pressed ? \"pressed\" : \"released\")")
        if pressed {
            self?.simulateKeyPress("i")
        }
    }
}
