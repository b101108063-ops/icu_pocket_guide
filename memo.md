打包 Web 版：

flutter build web --base-href "/icu_pocket_guide/" --release
搬移檔案：
清空 docs。
複製 build/web 到 docs。
補上 .nojekyll。


上傳：

git add .
git commit -m "Refactor to System-based structure"
git push
這樣您的 App 就會變成一個結構清晰、分類明確的 ICU Survival Guide 2.0 了！點進去「Respiratory」就能看到所有的呼吸相關功能，不需要在首頁大海撈針。