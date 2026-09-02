---
name: data-source-verification
description: >-
  Use this skill whenever selecting or switching which external API/endpoint
  to integrate with, and especially right before writing or modifying any
  code that parses a response from one — regardless of project or language.
  Two triggers. First, evaluating candidate data sources for the same
  underlying data (e.g. choosing between several endpoints, feeds, or
  vendors) — use this alongside verify-before-trust for the "don't stop at
  the first plausible explanation" comparison discipline; this skill adds
  the dimensions that discipline doesn't cover (legality/ToS, freshness,
  parse difficulty as three separate questions). Second, and more narrowly,
  about to write a parser for any API response whose exact shape (field
  names, order, nesting, date/number formats) hasn't been verified with a
  real captured sample — this is the core of the skill and applies even when
  fairly confident of the format from having seen similar APIs before.
  Trigger this especially when working from an agent or sandbox with no live
  network access and a human or another agent has real access instead.
---

# 資料源評估與「先拿真實樣本、再寫解析器」

## 這個skill涵蓋什麼、跟`verify-before-trust`的分工

「同一時刻比較所有候選來源、不要停在第一個聽起來合理的解釋」這個紀律，`verify-before-trust`的Part 2已經寫得很完整，這裡不重複。這個skill補的是`verify-before-trust`沒涵蓋到的兩塊：

1. **評估候選資料源時，把「合不合法/連不連得到」「新不新鮮」「好不好解析」當成三個獨立問題**——這三者常被混著判斷，但答案可能各自不同，`verify-before-trust`的候選比較框架沒有特別拆開這幾個維度。
2. **選定來源、要開始寫解析程式碼之前，必須先拿到一份真實的原始回應樣本，不能靠印象或「這類API通常長怎樣」的一般認知去猜格式**——這是一條獨立於「調查資料源是否可靠」的工程紀律，任何要跟外部API整合的場景都適用，不限於調查延遲/不準的情境。

## 一、評估候選來源：三個獨立問題

- **合不合法、連不連得到**：查robots.txt、使用條款、API的官方使用限制。但「查到限制」不等於「自動判定不能用」——**限制的性質不同，該有的謹慎程度也不同**：
  - **服務條款白紙黑字禁止特定用途**（例如某資料源明文禁止用於特定產業的商業服務）是有法律意涵的合約條款，這種要直接排除，沒有模糊空間。
  - **robots.txt**是網站單方面對自動化程式的請求，不是法律義務，不遵守沒有自動的法律後果——真正的風險是**實際後果**（例如高頻率呼叫被鎖IP），不是「查到disallow就等於違法」。真實案例：曾經查到一個端點的其中一條路徑被robots.txt disallow，第一輪判斷直接排除整個資料源；後來被追問「這是法律風險還是操作風險」，才想清楚——**這個判斷還要放進實際使用情境一起衡量**：個人自用、不轉售、不對外提供服務、只在使用者主動觸發時才打一次（不是排程高頻輪詢），這種用法的實際風險趨近於零，跟「拿別人的資料商業化」完全不是同一個量級。反過來，如果是要對外提供服務、高頻排程輪詢，同一個disallow就該認真看待。
  - 反過來也要注意：法規上明確開放給第三方使用的資料（例如官方開放資料平台）跟「網站自己前端在用、沒有明確開放」的端點，風險等級不一樣，即使後者技術上更方便。
  - **這條本身也是「找到一個理由就停手」的翻版**：查到disallow就直接下「不能用」的結論，跟`verify-before-trust`要提防的思維陷阱是同一種——差別只在於這次卡住判斷的不是「資料對不對」，是「這個限制的性質跟嚴重程度有沒有問我清楚」。
- **新不新鮮**：這個來源「現在」有沒有你要的那筆資料，不是「理論上多快更新」——用`verify-before-trust`的同一時刻比較方法拿到的實測結果，不是猜的。
- **好不好解析**：回應格式複雜度（巢狀結構、要不要額外處理HTML/分頁/編碼）。這點常常被忽略到動手實作才發現，值得在選定來源前就一併估算，因為它直接影響後續維護成本。

三者分開判斷之後，再決定要不要接受某個權衡（例如「稍微難解析一點，但比較新鮮」），而不是被其中一個因素主導了判斷，忽略了另外兩個。

## 二、動手寫解析器之前，先拿到真實原始樣本

### 為什麼「用印象猜格式」比看起來危險得多

猜錯一個API回應的欄位順序、資料型態、或巢狀結構，後果不是「程式碼報錯」——通常是**解析邏輯安靜地跑成功，但拿到的數字是錯的**。更麻煩的是，如果測試資料也是憑同一份印象手造的，測試會自我驗證出一個「看起來通過、實際上驗證的是錯誤假設」的結果，不會抓到問題。這比「這個功能還沒做」或「暫時抓不到資料」嚴重得多——後者是誠實的失敗，前者是看起來成功、實際上寫入錯誤資料。

即使你對某個API的一般格式有很高的信心（例如「同一家伺服器的其他端點都用`{fields, data}`這種陣列格式」），這是一個合理的**假設**，不是**驗證過的事實**——在真正驗證之前，用假設的信心程度去決定「要不要先動手寫」是危險的，因為信心程度不會顯示在最後寫進資料庫的數字上。

### 如果你自己連不到這個API（no live network access）

如果你在一個沒有對外網路存取的環境裡工作（例如某個沙盒/agent runtime限制對外連線），而任務需要判斷一個外部API實際回應長什麼樣，**不要用你對類似API的一般知識去填補這個缺口**。正確做法：明確請有真實存取權限的人或協作者（另一個agent、真人使用者）直接貼一次完整的原始回應，或至少是欄位定義＋一筆真實資料列，而不是他們已經解析過的摘要數字（摘要數字驗證不了你要寫的解析邏輯本身對不對）。

等待真實樣本的期間，可以先準備其他不需要真實資料就能做的部分（既有欄位的計算邏輯、跟這個新資料源無關的前端顯示邏輯），避免完全卡住，但也不要因為想加快進度就先用猜的把解析邏輯寫下去——這是一個「寧可暫停，也不要用猜的往下走」的場景，跟一般「先動手、有問題再修」的開發習慣是刻意相反的，因為這裡出錯的代價（安靜寫入錯誤資料）遠高於暫停等待的代價。

### 用真實樣本寫純函式，並且用同一份樣本寫測試

把解析邏輯寫成不碰網路、不碰資料庫的純函式（輸入原始payload、輸出乾淨的結構化資料），這樣才能離線測試，也才能直接把拿到的真實樣本當測試fixture用，而不是憑空造假資料：

```python
# 範例：解析邏輯直接吃拿到的真實原始回應（節錄），不是憑空造的結構
REAL_SAMPLE = {
    "stat": "OK",
    "fields": ["日期", "數值", "變化量"],
    "data": [
        ["2026/08/19", "44,719.35", "-589.33"],
        # ...更多真實列，照對方貼的原始回應節錄
    ],
}

def test_parser_handles_real_sample():
    rows = parse(REAL_SAMPLE)
    assert rows[-1]["value"] == 44719.35
```

測試斷言直接對照真實樣本裡看得到的數字，這樣測試本身也是「用真實資料驗證過」，不會變成自我循環的假驗證。

## 一頁式檢查清單

- [ ] 已經分開判斷過合法性/ToS、新鮮度、解析難度這三件事，沒有把它們混著判斷
- [ ] 選定來源後，動手寫解析器之前，手上已經有真實的原始回應樣本（不是摘要數字，不是憑印象猜的）
- [ ] 如果自己連不到這個API，已經明確跟有存取權限的人／協作者要了真實樣本，而不是用一般知識填補空白
- [ ] 解析邏輯寫成純函式，測試直接用真實樣本當fixture，不是憑空造的假資料
