Set ToolName=upm
Set ToolVersion=0.0.3
Set ToolAssetPath=Assets/testpackage

git subtree split --prefix=%ToolAssetPath% --branch %ToolName%
git tag %ToolVersion% %ToolName%

git push origin %ToolName% %ToolVersion%
git push origin %ToolName%

pause