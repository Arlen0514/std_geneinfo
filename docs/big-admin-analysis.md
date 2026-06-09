# Big Admin Analysis

## 待確認結論補充

### 前台 JSP 放置規則

前台 JSP 通常放在 `std_bg/web/` 對應功能資料夾下。

`art/web/` 是設計 HTML 雛形參考。轉 JSP 時，以 `art/web` HTML 結構為主，搬到 `std_bg/web` 對應位置後，再套入 `config.jspf`、include、資料查詢與迴圈。

### lang_setup

`lang_setup` 為多語系 key-value 類資料表，目前不作為一般建站優先模組。

若既有頁面未使用，不要主動導入。

### 前台主選單

前台主選單依專案需求處理。

若 `include/top_menu.jsp` 尚未完成，不要自行設計全新選單邏輯。應先參考既有專案或使用者提供的前台選單範例，再套入動態資料。
