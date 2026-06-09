# 模組選用指南

本文件依既有大後台 JSP 用法整理，供建站時依 `art/` 設計稿需求選擇後台模組。若設計稿需要的資料結構在既有程式找不到依據，先標為「待確認」，不要自行新增未確認規則。

## 圖片/檔案路徑總原則

圖片/檔案路徑通常為 `uploads/{code}/{lang}/`。

但如果檔案是由子模組維護，或同一頁面讀取不同模組資料，就不能只用目前頁面的 `page_code` 判斷路徑。前台 JSP 組圖片/檔案路徑時，必須依該筆資料實際所屬模組 code 組合。

例如同一頁同時有 `sub_banner`、`news`、`download`，路徑要分別依 `sub_banner`、`news`、`download` 組，不可全部套用同一個 page code。

## 快速對照

| 需求類型 | 建議使用模組 | 主資料表 | 分類/附表 | 常用 code |
|---|---|---|---|---|
| 最新消息列表 | news | `tblnp` / `news_profile` | 可搭 `tbldm` | `news`、`news2` |
| 最新消息內頁 | news | `tblnp` / `news_profile` | 可搭 `tbldm` | `news`、`news2` |
| 檔案下載 | download | `tblfd` / `file_detail` | 可搭 `tbldm` | `download` |
| 相關連結 | link/content | `tblcp` / `content_profile` | 可搭 `tbldm` | `link` |
| 單篇內容 | content | `tblcp` / `content_profile` | 通常無 | `one_content`、`about`、`contact_info` |
| Banner | banner/sub_banner | `tblap` / `ad_profile` | 通常無 | `banner`、`sub_banner` |
| 產品列表 | product | `tblpd` / `product_detail` | `tblpi`、可搭 `tbldm` | `product` |
| 聯絡表單 | contact | `tblcu` / `contact_us` | 內容說明可搭 `tblcp` | `contact`、`contact_info` |
| FAQ | content/qa | `tblcp` / `content_profile` | 可搭 `tbldm` | `qa` |
| 影片 | content/video | `tblcp` / `content_profile` | 可搭 `tbldm` | `video` |
| 相簿 | photo | `tblap` / `ad_profile` | 相簿內圖用 `photo_in` | `photo`、`photo_in` |
| 分類選單 | dm | `tbldm` / `down_menu` | 自我階層 | `*_category`、`file_type` |
| 附加檔案 | fd | `tblfd` / `file_detail` | 用 `fk_id` 掛主資料 | `file` |
| 語系 | lang_setup | `lang_setup` | 待確認 | 待確認 |

## 需求類型

### 最新消息列表

- 建議使用模組：news。
- 後台 JSP 位置：`std_bg/mis/nolevel/news*.jsp`、`std_bg/mis/onelevel/news*.jsp`、`std_bg/mis/twolevel/news*.jsp`。
- 主資料表：`tblnp` / `news_profile`。
- 分類表或附表：需要分類時用 `tbldm` / `down_menu`，例如 `news_category`。
- 常用 code：`news`、`news2`。
- 前台常見查詢方式：`app_sm.selectAll(tblnp, "np_code=? and np_lang=?", new Object[]{ code, lang }, "np_emitdate DESC, np_createdate DESC")`；有分類時加 `np_category` 或 `np_upcategory` 條件。
- 圖片/檔案路徑規則：新聞資料的圖片通常依新聞資料實際 code 組成 `uploads/{np_code}/{lang}/{np_image}`；不要因為目前頁面 code 不同就改用頁面 code。
- 什麼情況不要用這個模組：只有單篇文字、單篇關於我們、固定頁內容時不要用 news，改用 content。
- 可參考檔案：`std_bg/mis/nolevel/news.jsp`、`std_bg/mis/nolevel/news_update.jsp`、`std_bg/mis/twolevel/news.jsp`、`std_bg/mis/twolevel/news_category.jsp`。

### 最新消息內頁

- 建議使用模組：news。
- 後台 JSP 位置：`std_bg/mis/*level/news_c.jsp` 為後台修改頁；前台內頁需依 `art/web` 設計稿客製。
- 主資料表：`tblnp` / `news_profile`。
- 分類表或附表：需要分類時用 `tbldm` / `down_menu`。
- 常用 code：`news`、`news2`。
- 前台常見查詢方式：用 `np_id` 查單筆，例如 `app_sm.select(tblnp, np_id)` 或 `app_sm.select(tblnp, "np_id=?", new Object[]{ np_id })`。
- 圖片/檔案路徑規則：使用該筆新聞實際所屬 code，例如 `uploads/{np_code}/{lang}/{np_image}`。若內頁同時讀 banner 或附件，banner 與附件要各自使用其資料所屬 code。
- 什麼情況不要用這個模組：內頁只是單篇固定內容時不要用 news；需要多檔附件時不要直接假設 `np_file` 足夠，先確認是否改用 `news2_download` 或 `tblfd`。
- 可參考檔案：`std_bg/mis/nolevel/news_c.jsp`、`std_bg/mis/nolevel/news2_c.jsp`、`std_bg/mis/nolevel/news2_download_update.jsp`。

### 檔案下載

- 建議使用模組：download。
- 後台 JSP 位置：`std_bg/mis/nolevel/download*.jsp`、`std_bg/mis/onelevel/download*.jsp`、`std_bg/mis/twolevel/download*.jsp`。
- 主資料表：`tblfd` / `file_detail`。
- 分類表或附表：需要分類時用 `tbldm` / `down_menu`，常見 `download_category`。
- 常用 code：`download`。
- 前台常見查詢方式：`app_sm.selectAll(tblfd, "fd_code=? and fd_lang=?", new Object[]{ code, lang }, "fd_showseq ASC, fd_createdate DESC")`；有分類時加 `fd_category`、`fd_upcategory`。
- 圖片/檔案路徑規則：下載資料通常依該筆檔案實際 `fd_code` 組成 `uploads/{fd_code}/{lang}/{fd_file}`；若 `fd_code` 是附加檔案用的 `file`，路徑需回到維護它的主模組 code，不能直接使用目前頁面 code。
- 什麼情況不要用這個模組：若只是主資料的一組附加檔案，不一定要開獨立 download 列表，可確認是否用 `tblfd.fk_id` 掛在主資料下。
- 可參考檔案：`std_bg/mis/nolevel/download.jsp`、`std_bg/mis/nolevel/download_update.jsp`、`std_bg/mis/twolevel/download.jsp`、`std_bg/mis/twolevel/download_category.jsp`。

### 相關連結

- 建議使用模組：link/content。
- 後台 JSP 位置：`std_bg/mis/nolevel/link*.jsp`、`std_bg/mis/onelevel/link*.jsp`、`std_bg/mis/twolevel/link*.jsp`。
- 主資料表：`tblcp` / `content_profile`。
- 分類表或附表：需要分類時用 `tbldm` / `down_menu`，常見 `link_category`。
- 常用 code：`link`。
- 前台常見查詢方式：`app_sm.selectAll(tblcp, "cp_code=? and cp_lang=?", new Object[]{ code, lang }, "cp_showseq ASC, cp_createdate DESC")`；連結網址使用 `cp_url`，開啟方式使用 `cp_target`。
- 圖片/檔案路徑規則：若有圖片，依該筆連結資料實際 `cp_code` 組成 `uploads/{cp_code}/{lang}/{cp_image}`。
- 什麼情況不要用這個模組：純分類選單不要新開 link 主資料；只有單篇連結說明文字時可用單篇 content。
- 可參考檔案：`std_bg/mis/nolevel/link.jsp`、`std_bg/mis/nolevel/link_update.jsp`、`std_bg/mis/twolevel/link.jsp`、`std_bg/mis/twolevel/link_category.jsp`。

### 單篇內容

- 建議使用模組：content。
- 後台 JSP 位置：`std_bg/mis/nolevel/one_content*.jsp`，也可依既有專案使用 `about*.jsp`、`contact_info*.jsp` 等 content 類模組。
- 主資料表：`tblcp` / `content_profile`。
- 分類表或附表：通常無；若設計稿需要列表或分類，改評估 link/qa/video 或分類版 content。
- 常用 code：`one_content`、`about`、`contact_info`、`index_about`。
- 前台常見查詢方式：`app_sm.select(tblcp, "cp_code=? and cp_lang=?", new Object[]{ code, lang })`，內容輸出 `cp_content`。
- 圖片/檔案路徑規則：若有圖片，依該筆內容資料實際 `cp_code` 組成 `uploads/{cp_code}/{lang}/{cp_image}`。
- 什麼情況不要用這個模組：多筆列表、需日期排序的消息不要用單篇內容；改用 news 或其他列表型模組。
- 可參考檔案：`std_bg/mis/nolevel/one_content.jsp`、`std_bg/mis/nolevel/one_content_update.jsp`、`std_bg/mis/nolevel/contact_info.jsp`、`std_bg/web/contact/contact.jsp`。

### Banner

- 建議使用模組：banner 或 sub_banner。
- 後台 JSP 位置：`std_bg/mis/nolevel/banner*.jsp`、`std_bg/mis/nolevel/sub_banner*.jsp`。
- 主資料表：`tblap` / `ad_profile`。
- 分類表或附表：通常無；`sub_banner` 會用 `ap_category` 對應頁面或單元。
- 常用 code：`banner`、`sub_banner`。
- 前台常見查詢方式：`app_sm.selectAll(tblap, "ap_code=? and ap_lang=?", new Object[]{ code, lang }, "ap_showseq ASC, ap_createdate DESC")`；內頁 banner 可再依 `ap_category` 查。
- 圖片/檔案路徑規則：依該筆 banner 資料實際 `ap_code` 組成，例如 `uploads/banner/{lang}/{ap_image}` 或 `uploads/sub_banner/{lang}/{ap_image}`；同頁若也讀 news/download，不可沿用 banner code。
- 什麼情況不要用這個模組：一般內容列表、新聞列表不要用 banner；內頁固定視覺若不需要後台維護，可先依專案確認是否靜態。
- 可參考檔案：`std_bg/mis/nolevel/banner.jsp`、`std_bg/mis/nolevel/banner_update.jsp`、`std_bg/mis/nolevel/sub_banner.jsp`、`std_bg/mis/nolevel/sub_banner_update.jsp`。

### 產品列表

- 建議使用模組：product。
- 後台 JSP 位置：`std_bg/mis/nolevel/product*.jsp`、`std_bg/mis/onelevel/product*.jsp`、`std_bg/mis/twolevel/product*.jsp`。
- 主資料表：`tblpd` / `product_detail`。
- 分類表或附表：產品多圖/附加資料用 `tblpi` / `product_info`；需要分類時用 `tbldm`，常見 `product_category`。
- 常用 code：`product`；熱門產品使用 `hot_product` 搭配 `data_code="product"`。
- 前台常見查詢方式：`app_sm.selectAll(tblpd, "pd_code=? and pd_lang=?", new Object[]{ code, lang }, "pd_showseq ASC, pd_createdate DESC")`；多圖查 `app_sm.selectAll(tblpi, "pd_id=? and pi_code=?", new Object[]{ pd_id, "img" })`。
- 圖片/檔案路徑規則：產品主圖與多圖依產品資料實際 `pd_code` 組成 `uploads/{pd_code}/{lang}/`；主圖用 `pd_image`，多圖用 `pi_image`。若同頁有首頁 banner 或最新消息，需分別用各自 code。
- 什麼情況不要用這個模組：只有單篇產品介紹不要用 product 列表；沒有產品欄位需求的圖文列表可評估 content 或 news。
- 可參考檔案：`std_bg/mis/nolevel/product.jsp`、`std_bg/mis/nolevel/product_update.jsp`、`std_bg/mis/twolevel/product_category.jsp`、`std_bg/mis/nolevel/hot_product.jsp`。

### 聯絡表單

- 建議使用模組：contact。
- 後台 JSP 位置：`std_bg/mis/nolevel/contact*.jsp`、`std_bg/mis/nolevel/contact_info*.jsp`。
- 主資料表：表單投稿用 `tblcu` / `contact_us`；聯絡頁說明內容用 `tblcp` / `content_profile`。
- 分類表或附表：無；寄信設定可能使用 `tblst` / `smtp_times` 或 `tblss`，依既有寄信頁。
- 常用 code：`contact`、`contact_info`。
- 前台常見查詢方式：頁面說明查 `app_sm.select(tblcp, "cp_code=? and cp_lang=?", new Object[]{ page_code+"_info", lang })`；表單送出用 `new TableRecord(tblcu)`，寫入 `cu_code=contact`、`cu_lang=lang`、`cu_reply=N`。
- 圖片/檔案路徑規則：一般聯絡表單不以圖片/檔案為主；若同頁讀取 `contact_info` 圖片，依 `contact_info` 的 `cp_code` 組路徑。若設計稿有檔案上傳，既有依據待確認。
- 什麼情況不要用這個模組：只有聯絡資訊文字，不需要投稿紀錄時，不要開 `contact_us` 表單資料，可用 `contact_info` 單篇內容。
- 可參考檔案：`std_bg/web/contact/contact.jsp`、`std_bg/web/contact/contact_update.jsp`、`std_bg/web/contact/contact_sendmail.jsp`、`std_bg/mis/nolevel/contact.jsp`、`std_bg/mis/nolevel/contact_info.jsp`。

### FAQ

- 建議使用模組：content/qa。
- 後台 JSP 位置：`std_bg/mis/nolevel/qa*.jsp`、`std_bg/mis/onelevel/qa*.jsp`、`std_bg/mis/twolevel/qa*.jsp`。
- 主資料表：`tblcp` / `content_profile`。
- 分類表或附表：需要分類時用 `tbldm` / `down_menu`，常見 `qa_category`。
- 常用 code：`qa`。
- 前台常見查詢方式：`app_sm.selectAll(tblcp, "cp_code=? and cp_lang=?", new Object[]{ "qa", lang }, "cp_showseq ASC, cp_createdate DESC")`；問題標題用 `cp_title`，答案內容用 `cp_content`。
- 圖片/檔案路徑規則：若有圖片，依該筆 FAQ 資料實際 `cp_code` 組成 `uploads/{cp_code}/{lang}/{cp_image}`；FAQ 通常以文字為主。
- 什麼情況不要用這個模組：只有一頁固定 FAQ 說明不要用多筆 qa，可用單篇 content；純分類不要新開主表。
- 可參考檔案：`std_bg/mis/nolevel/qa.jsp`、`std_bg/mis/nolevel/qa_update.jsp`、`std_bg/mis/twolevel/qa_category.jsp`。

### 影片

- 建議使用模組：content/video。
- 後台 JSP 位置：`std_bg/mis/nolevel/video*.jsp`、`std_bg/mis/onelevel/video*.jsp`、`std_bg/mis/twolevel/video*.jsp`。
- 主資料表：`tblcp` / `content_profile`。
- 分類表或附表：需要分類時用 `tbldm` / `down_menu`，常見 `video_category`。
- 常用 code：`video`。
- 前台常見查詢方式：`app_sm.selectAll(tblcp, "cp_code=? and cp_lang=?", new Object[]{ "video", lang }, "cp_showseq ASC, cp_createdate DESC")`；影片欄位可參考 `cp_video`。
- 圖片/檔案路徑規則：封面圖若使用 `cp_image`，依該筆影片資料實際 `cp_code` 組成 `uploads/{cp_code}/{lang}/{cp_image}`。
- 什麼情況不要用這個模組：單支固定嵌入影片可用單篇 content；需要複雜影音平台欄位時待確認。
- 可參考檔案：`std_bg/mis/nolevel/video.jsp`、`std_bg/mis/nolevel/video_update.jsp`、`std_bg/mis/twolevel/video_category.jsp`。

### 相簿

- 建議使用模組：photo。
- 後台 JSP 位置：`std_bg/mis/nolevel/photo*.jsp`、`std_bg/mis/*level/photo_in*.jsp`。
- 主資料表：`tblap` / `ad_profile`。
- 分類表或附表：相簿主資料使用 `photo`；相簿內圖片使用 `photo_in`，以 `ap_category` 掛回相簿 `ap_id`。
- 常用 code：`photo`、`photo_in`。
- 前台常見查詢方式：相簿列表查 `app_sm.selectAll(tblap, "ap_code=? and ap_lang=?", new Object[]{ "photo", lang })`；相簿內圖查 `app_sm.selectAll(tblap, "ap_category=? and ap_code=? and ap_lang=?", new Object[]{ ap_category, "photo_in", lang })`。
- 圖片/檔案路徑規則：相簿封面依 `photo` 組成 `uploads/photo/{lang}/{ap_image}`；相簿內圖依子模組 `photo_in` 與相簿 ID 組成 `uploads/photo_in/{lang}/{ap_category}/{ap_image}`。這是子模組路徑，不可只用目前頁面 code。
- 什麼情況不要用這個模組：只有單張 banner 或內頁視覺不要用相簿；多圖但不需要相簿階層時先確認是否使用產品多圖或其他模組。
- 可參考檔案：`std_bg/mis/nolevel/photo.jsp`、`std_bg/mis/nolevel/photo_update.jsp`、`std_bg/mis/nolevel/photo_in.jsp`、`std_bg/mis/nolevel/photo_in_update.jsp`。

### 分類選單

- 建議使用模組：dm。
- 後台 JSP 位置：各模組的 `*_category*.jsp`，例如 `news_category.jsp`、`download_category.jsp`、`link_category.jsp`。
- 主資料表：`tbldm` / `down_menu`。
- 分類表或附表：`down_menu` 自我階層，使用 `dm_category` 表示父層，`dm_upcategory` 在部分資料表作為上一層分類欄位。
- 常用 code：`news_category`、`download_category`、`link_category`、`product_category`、`qa_category`、`video_category`、`file_type`。
- 前台常見查詢方式：`app_sm.selectAll(tbldm, "dm_code=? and dm_lang=? and dm_category=?", new Object[]{ code, lang, parentId }, "dm_showseq ASC, dm_createdate DESC")`。
- 圖片/檔案路徑規則：若分類有圖片，依分類資料實際 `dm_code` 組成 `uploads/{dm_code}/{lang}/{dm_image}`；不是所有分類頁都一定使用圖片。
- 什麼情況不要用這個模組：純分類不要新開主表；分類只是主資料的輔助時使用 `down_menu`，不要自建一張分類表。
- 可參考檔案：`std_bg/mis/mis_tools/category_selector.jsp`、`std_bg/mis/twolevel/download_category.jsp`、`std_bg/mis/twolevel/link_category.jsp`、`std_bg/mis/twolevel/product_category.jsp`。

### 附加檔案

- 建議使用模組：fd。
- 後台 JSP 位置：獨立下載使用 `download*.jsp`；附加到內容的例子在 `news2_download*.jsp`。
- 主資料表：`tblfd` / `file_detail`。
- 分類表或附表：掛主資料時用 `fk_id` 指向主資料 ID，並用 `fd_code` 區分用途；檔案類型可用 `tbldm` 的 `file_type`。
- 常用 code：獨立下載用 `download`；附加檔案常見 `fd_code="file"`。
- 前台常見查詢方式：掛主資料時 `app_sm.selectAll(tblfd, "fd_code=? and fk_id=?", new Object[]{ "file", cp_id }, "fd_showseq ASC, fd_createdate DESC")`。
- 圖片/檔案路徑規則：附加檔案路徑必須依維護它的實際模組組成。例如 `news2_download` 維護的附檔為 `uploads/news2_download/{lang}/{fd_file}`，獨立 download 則為 `uploads/download/{lang}/{fd_file}`；不能只看目前前台頁面的 page code。
- 什麼情況不要用這個模組：只有一個主檔案且既有主表已有 `*_file` 欄位時，不一定要加 `tblfd`；需要多檔附件時才優先確認 `tblfd`。
- 可參考檔案：`std_bg/mis/nolevel/news2_download_update.jsp`、`std_bg/mis/nolevel/news2_download_c.jsp`、`std_bg/mis/nolevel/download_update.jsp`。

### 語系

- 建議使用模組：lang_setup。
- 後台 JSP 位置：待確認。
- 主資料表：`lang_setup`。
- 分類表或附表：待確認。
- 常用 code：待確認。
- 前台常見查詢方式：待確認。既有頁面若未使用，不要主動導入。
- 圖片/檔案路徑規則：待確認。
- 什麼情況不要用這個模組：一般建站頁面若既有 `lang`、`site_setup`、各資料表 `*_lang` 已足夠，不要主動改導入 `lang_setup`。
- 可參考檔案：`DB/sql_modify_20260305.txt`、`std_bg/WEB-INF/classes/local/beans/LangSetupBean.java`。

## 選用原則

- 先讀 `art/` 設計稿，確認頁面是單篇、列表、分類列表、表單、banner、相簿或產品。
- 先依頁面架構開後台維護模組；後台維護完成後，再把 HTML 設計稿轉成 JSP 並套入後台資料。
- 前台 JSP 通常放在 `std_bg/web/` 對應功能資料夾下，但實際資料夾與 URL 依專案需求決定。
- 前台 JSP 同一頁可能讀取多個模組資料；圖片/檔案路徑必須依每筆資料實際所屬模組 code 組成，不可全部套用同一個 page code。
- 不要因為前台需要一個分類下拉，就新開主資料表；優先使用 `down_menu`。
- 不要因為頁面有一段文字就使用 news；固定單篇內容優先使用 content。
- 需要多檔附件時先確認是否使用 `tblfd`，不要把多檔硬塞進單一 `*_file` 欄位。
- 前台主選單依專案需求處理；若 `include/top_menu.jsp` 尚未完成，不要自行設計全新選單邏輯，先參考既有專案或使用者提供的範例。
- 目前後台建置流程：
  1. 先依 `art/` 設計稿判斷需要哪些維護項目。
  2. 到 `/mis/module/menu.jsp` 開好後台維護目錄/選單。
  3. 再把選定的既有模組複製到 `/mis/basic/`。
  4. 在 `/mis/basic/` 內依需求調整模組程式。
  5. 後台維護完成後，再撰寫前台 JSP 並套入資料。
