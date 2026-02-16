打包 Web 版：

flutter build web --base-href "/icu_pocket_guide/" --release

# 1. 刪除舊的 docs 資料夾 (如果存在)
if (Test-Path docs) { Remove-Item -Recurse -Force docs }

# 2. 建立新的 docs 資料夾
New-Item -ItemType Directory -Force docs

# 3. 把 build/web 的內容全部複製過去
Copy-Item -Recurse build\web\* docs\

# 4. 補上 .nojekyll 檔案 (這步最重要！)
New-Item -ItemType File docs\.nojekyll

# 顯示成功訊息
Write-Host "✅ 搬移完成！準備上傳！" -ForegroundColor Green

上傳：

git add .
git commit -m "Refactor to System-based structure"
git push
這樣您的 App 就會變成一個結構清晰、分類明確的 ICU Survival Guide 2.0 了！點進去「Respiratory」就能看到所有的呼吸相關功能，不需要在首頁大海撈針。