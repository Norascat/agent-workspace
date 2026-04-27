#!/bin/bash
# ClaudeCat Setup — 双击此文件即可运行（macOS）
# 首次运行前：右键 → 打开（绕过 Gatekeeper 首次确认）

# 切到脚本所在目录（双击时 cwd 不一定正确）
cd "$(dirname "$0")"

bash "$(dirname "$0")/install.sh"

echo ""
read -p "按 Enter 关闭窗口..."
