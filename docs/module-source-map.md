# 模組來源地圖

本文件用來判斷建站時應從哪個既有大後台模組複製到 `/mis/basic/` 後再客製。依據來自既有 JSP 檔案與共用表名設定，不把 `/mis/basic/` 當成標準模組來源區。

## `/mis/basic/` 定位

`/mis/basic/` 是專案客製區，不是標準模組庫。

新專案一開始 `/mis/basic/` 可能是空的。建站時應先從既有模組區尋找最接近需求的模組，例如 `/mis/nolevel/`、`/mis/onelevel/`、`/mis/twolevel/`、`/mis/module/`、`/mis/special/`，複製到 `/mis/basic/` 後再依專案需求調整。

## 建站流程

1. 先依 `art/` 設計稿判斷需要哪些後台維護項目。
2. 到 `/mis/module/menu.jsp` 開好後台維護目錄/選單。
3. 從既有模組區尋找最接近功能的模組。
4. 將選定的既有模組複製到 `/mis/basic/`。
5. 在 `/mis/basic/` 內依需求調整模組程式。
6. 後台維護完成後，再撰寫前台 JSP 並套入資料。

## 模組來源對照表

| 模組 | 需求類型 | 優先參考來源路徑 | 主資料表 | 分類/附表 | 常用 code |
|---|---|---|---|---|---|
| news | 最新消息、活動消息 | `std_bg/mis/nolevel/news*.jsp`; 有分類看 `onelevel`/`twolevel` | `tblnp` / `news_profile` | `tbldm` / `down_menu` | `news`、`news2` |
| download | 檔案下載 | `std_bg/mis/nolevel/download*.jsp`; 有分類看 `onelevel`/`twolevel` | `tblfd` / `file_detail` | `tbldm` / `down_menu` | `download` |
| link | 相關連結 | `std_bg/mis/nolevel/link*.jsp`; 有分類看 `onelevel`/`twolevel` | `tblcp` / `content_profile` | `tbldm` / `down_menu` | `link` |
| one_content / about / contact_info | 單篇內容、關於我們、聯絡資訊 | `std_bg/mis/nolevel/one_content*.jsp`; `about*.jsp`; `contact_info*.jsp` | `tblcp` / `content_profile` | 通常無 | `one_content`、`about`、`contact_info` |
| banner | 首頁 banner | `std_bg/mis/nolevel/banner*.jsp` | `tblap` / `ad_profile` | 通常無 | `banner` |
| sub_banner | 內頁 banner | `std_bg/mis/nolevel/sub_banner*.jsp` | `tblap` / `ad_profile` | `ap_category` 對應頁面/單元 | `sub_banner` |
| qa | FAQ | `std_bg/mis/nolevel/qa*.jsp`; 有分類看 `onelevel`/`twolevel` | `tblcp` / `content_profile` | `tbldm` / `down_menu` | `qa` |
| video | 影片 | `std_bg/mis/nolevel/video*.jsp`; 有分類看 `onelevel`/`twolevel` | `tblcp` / `content_profile` | `tbldm` / `down_menu` | `video` |
| photo / photo_in | 相簿、相簿內圖片 | `std_bg/mis/nolevel/photo*.jsp`; `photo_in*.jsp` | `tblap` / `ad_profile` | `photo_in.ap_category` 掛相簿 ID | `photo`、`photo_in` |
| product / hot_product | 產品、熱門產品 | `std_bg/mis/nolevel/product*.jsp`; `hot_product*.jsp`; 有分類看 `onelevel`/`twolevel` | `tblpd` / `product_detail` | `tblpi` / `product_info`; `tbldm` / `down_menu` | `product`、`hot_product` |
| down_menu | 分類選單 | 各模組 `*_category*.jsp`; `std_bg/mis/mis_tools/category_selector.jsp` | `tbldm` / `down_menu` | 自我階層 | `*_category`、`file_type` |
| file_detail | 附加檔案、多檔附件 | `download*.jsp`; `news2_download*.jsp` | `tblfd` / `file_detail` | `fk_id` 掛主資料；`file_type` | `download`、`file` |
| contact / contact_info | 聯絡表單、聯絡資訊 | `std_bg/mis/nolevel/contact*.jsp`; `contact_info*.jsp`; 前台參考 `std_bg/web/contact/*.jsp` | `tblcu` / `contact_us`; `tblcp` / `content_profile` | 寄信設定依既有頁，待確認 | `contact`、`contact_info` |
| lang_setup | 語系 | 待確認；目前可參考 `LangSetupBean.java` 與 SQL 更新檔 | `lang_setup` | 待確認 | 待確認 |

## 模組細節

### 最新消息 news

- 需求類型：最新消息列表、活動消息列表、消息內頁。
- 優先參考來源路徑：無分類先看 `std_bg/mis/nolevel/news*.jsp`；一層分類看 `std_bg/mis/onelevel/news*.jsp` 與 `news_category*.jsp`；二層分類看 `std_bg/mis/twolevel/news*.jsp` 與 `news_category*.jsp`。
- 主資料表：`tblnp` / `news_profile`。
- 分類/附表：分類使用 `tbldm` / `down_menu`，常見 `news_category`、`news2_category`。
- 常用 code：`news`、`news2`。
- 適合使用情境：多筆消息、活動、公告，需日期、列表、內頁、排序或分類。
- 不適合使用情境：只有單篇固定文字或關於我們頁面，應改用 content；需要多檔附件時需確認 `news2_download` 或 `file_detail` 是否更合適。

### 檔案下載 download

- 需求類型：檔案下載列表、下載分類。
- 優先參考來源路徑：無分類先看 `std_bg/mis/nolevel/download*.jsp`；有分類看 `std_bg/mis/onelevel/download*.jsp` 或 `std_bg/mis/twolevel/download*.jsp`。
- 主資料表：`tblfd` / `file_detail`。
- 分類/附表：分類使用 `tbldm` / `down_menu`，常見 `download_category`。
- 常用 code：`download`。
- 適合使用情境：每筆資料以可下載檔案為主，前台需要下載列表或分類篩選。
- 不適合使用情境：只是某個主資料的多檔附件時，不一定要開 download 主列表，應評估 `file_detail.fk_id` 附加檔案模式。

### 相關連結 link

- 需求類型：相關連結、外部連結、可分類連結列表。
- 優先參考來源路徑：無分類先看 `std_bg/mis/nolevel/link*.jsp`；有分類看 `std_bg/mis/onelevel/link*.jsp` 或 `std_bg/mis/twolevel/link*.jsp`。
- 主資料表：`tblcp` / `content_profile`。
- 分類/附表：分類使用 `tbldm` / `down_menu`，常見 `link_category`。
- 常用 code：`link`。
- 適合使用情境：每筆資料有標題、圖片、URL、target，前台呈現相關連結清單。
- 不適合使用情境：純分類選單不要新開主資料；只有單篇說明文字時應用單篇 content。

### 單篇內容 one_content / about / contact_info

- 需求類型：單篇內容、關於我們、聯絡資訊、首頁單段介紹。
- 優先參考來源路徑：`std_bg/mis/nolevel/one_content*.jsp`、`std_bg/mis/nolevel/about*.jsp`、`std_bg/mis/nolevel/contact_info*.jsp`。
- 主資料表：`tblcp` / `content_profile`。
- 分類/附表：通常無。
- 常用 code：`one_content`、`about`、`contact_info`、`index_about`。
- 適合使用情境：設計稿只有一頁固定內容，或一個區塊由後台維護標題、內文、圖片、SEO。
- 不適合使用情境：多筆列表、消息日期排序、產品規格、多檔附件。

### Banner banner

- 需求類型：首頁 banner、輪播圖。
- 優先參考來源路徑：`std_bg/mis/nolevel/banner*.jsp`.
- 主資料表：`tblap` / `ad_profile`。
- 分類/附表：通常無。
- 常用 code：`banner`。
- 適合使用情境：首頁輪播、主視覺，可維護圖片、手機圖、連結、排序、上下架日期。
- 不適合使用情境：一般內容列表、消息列表、相簿。

### 內頁 Banner sub_banner

- 需求類型：各單元內頁 banner、內頁主視覺。
- 優先參考來源路徑：`std_bg/mis/nolevel/sub_banner*.jsp`。
- 主資料表：`tblap` / `ad_profile`。
- 分類/附表：使用 `ap_category` 對應頁面或單元代碼。
- 常用 code：`sub_banner`。
- 適合使用情境：多個內頁各自需要一張或一組可維護 banner。
- 不適合使用情境：純靜態且專案確認不需後台維護的內頁視覺。

### FAQ qa

- 需求類型：常見問題列表、FAQ 分類。
- 優先參考來源路徑：無分類先看 `std_bg/mis/nolevel/qa*.jsp`；有分類看 `std_bg/mis/onelevel/qa*.jsp` 或 `std_bg/mis/twolevel/qa*.jsp`。
- 主資料表：`tblcp` / `content_profile`。
- 分類/附表：分類使用 `tbldm` / `down_menu`，常見 `qa_category`。
- 常用 code：`qa`。
- 適合使用情境：多筆問答，標題作為問題、內容作為答案，可排序或分類。
- 不適合使用情境：只有一頁固定 FAQ 說明，應用單篇 content；純分類不要新開主資料。

### 影片 video

- 需求類型：影片列表、影片分類。
- 優先參考來源路徑：無分類先看 `std_bg/mis/nolevel/video*.jsp`；有分類看 `std_bg/mis/onelevel/video*.jsp` 或 `std_bg/mis/twolevel/video*.jsp`。
- 主資料表：`tblcp` / `content_profile`。
- 分類/附表：分類使用 `tbldm` / `down_menu`，常見 `video_category`。
- 常用 code：`video`。
- 適合使用情境：多筆影片資料，需標題、內容、影片欄位、封面圖、分類。
- 不適合使用情境：單支固定嵌入影片可用單篇 content；複雜影音平台欄位待確認。

### 相簿 photo / photo_in

- 需求類型：相簿列表、相簿內多張圖片。
- 優先參考來源路徑：`std_bg/mis/nolevel/photo*.jsp`、`std_bg/mis/nolevel/photo_in*.jsp`；有分類需求可看 `onelevel` / `twolevel` 的 photo 模組。
- 主資料表：`tblap` / `ad_profile`。
- 分類/附表：相簿主資料用 `photo`；相簿內圖片用 `photo_in`，並以 `ap_category` 掛回相簿 ID。
- 常用 code：`photo`、`photo_in`。
- 適合使用情境：設計稿有相簿列表與相簿內頁多圖管理。
- 不適合使用情境：只有首頁 banner 或單張內頁 banner；產品多圖應先看 product / `tblpi`。

### 產品 product / hot_product

- 需求類型：產品列表、產品內頁、熱門產品。
- 優先參考來源路徑：`std_bg/mis/nolevel/product*.jsp`；熱門產品看 `std_bg/mis/nolevel/hot_product*.jsp`；有分類看 `onelevel` / `twolevel` 的 `product*.jsp` 與 `product_category*.jsp`。
- 主資料表：`tblpd` / `product_detail`。
- 分類/附表：多圖/附加資料使用 `tblpi` / `product_info`；分類使用 `tbldm` / `down_menu`。
- 常用 code：`product`、`hot_product`。
- 適合使用情境：需要產品標題、規格、內容、主圖、多圖、熱門排序或分類。
- 不適合使用情境：單篇產品介紹；一般新聞或圖文列表。

### 分類 down_menu

- 需求類型：各模組分類、下拉分類、檔案類型。
- 優先參考來源路徑：各模組 `*_category*.jsp`；分類選取工具看 `std_bg/mis/mis_tools/category_selector.jsp`。
- 主資料表：`tbldm` / `down_menu`。
- 分類/附表：`down_menu` 自我階層，使用 `dm_category` 表示父層。
- 常用 code：`news_category`、`download_category`、`link_category`、`product_category`、`qa_category`、`video_category`、`file_type`。
- 適合使用情境：主資料需要一層或二層分類，或需要維護檔案類型。
- 不適合使用情境：純分類不要新開主資料表；不要為每個分類需求自建新表。

### 附加檔案 file_detail

- 需求類型：多檔附件、主資料附檔、檔案下載。
- 優先參考來源路徑：獨立下載看 `download*.jsp`；主資料多檔附件看 `std_bg/mis/nolevel/news2_download*.jsp`。
- 主資料表：`tblfd` / `file_detail`。
- 分類/附表：`fk_id` 掛主資料 ID；`fd_code` 區分用途；檔案類型可搭 `file_type`。
- 常用 code：`download`、`file`。
- 適合使用情境：同一筆主資料需要多個附件，或設計稿要求獨立下載列表。
- 不適合使用情境：只有單一檔案且既有主表 `*_file` 欄位足夠時，不一定要使用 `file_detail`。

### 聯絡表單 contact / contact_info

- 需求類型：聯絡我們表單、聯絡資訊內容。
- 優先參考來源路徑：後台看 `std_bg/mis/nolevel/contact*.jsp`、`std_bg/mis/nolevel/contact_info*.jsp`；前台表單流程參考 `std_bg/web/contact/*.jsp`。
- 主資料表：表單投稿使用 `tblcu` / `contact_us`；聯絡頁文字使用 `tblcp` / `content_profile`。
- 分類/附表：寄信設定依既有頁面，待確認。
- 常用 code：`contact`、`contact_info`。
- 適合使用情境：前台有表單送出、後台需要查看聯絡紀錄；或聯絡頁上方文字需要後台維護。
- 不適合使用情境：只有靜態聯絡資訊且不需投稿紀錄時，可只用 `contact_info` 或靜態前台，依專案確認。

### 語系 lang_setup

- 需求類型：語系 key-value。
- 優先參考來源路徑：待確認；目前只確認 `std_bg/WEB-INF/classes/local/beans/LangSetupBean.java` 與 `DB/sql_modify_20260305.txt`。
- 主資料表：`lang_setup`。
- 分類/附表：待確認。
- 常用 code：待確認。
- 適合使用情境：多語系 key-value 需求且既有頁面已有使用依據時。
- 不適合使用情境：一般建站優先不要主動導入；若既有頁面未使用，不要自行新建語系機制。

## 設計稿分析時的輸出格式

分析 `art/` 設計稿時，建議先輸出以下格式，確認後再開始複製與調整模組：

```markdown
## 後台維護項目規劃

| 設計稿頁面/區塊 | 需求類型 | 建議模組 | 來源路徑 | 複製到 /mis/basic/ 後檔名 | 主資料表 | 分類/附表 | 常用 code | 待確認 |
|---|---|---|---|---|---|---|---|---|
| 首頁 banner | Banner | banner | std_bg/mis/nolevel/banner*.jsp | basic/banner*.jsp | tblap | 無 | banner | 圖片尺寸 |
| 最新消息列表 | 最新消息 | news | std_bg/mis/nolevel/news*.jsp | basic/news*.jsp | tblnp | 視分類需求 | news | 是否分類 |
```

每個項目至少說明：

- 對應的 `art/` 頁面或區塊。
- 需求類型。
- 建議模組與來源路徑。
- 是否需要分類。
- 是否需要附加檔案。
- 圖片/檔案由哪個模組維護，前台路徑應依哪個 code 組。
- 待確認事項，例如圖片尺寸、是否多語系、是否需要上下架日期、是否需要排序。
