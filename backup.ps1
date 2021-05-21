Set-Location /Users/joseph/code/instructions
$date = Get-Date -Format "yyyy-mm-dd"
git checkout master
git add .
git commit -m $date
git push