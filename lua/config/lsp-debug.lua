-- ==========================================
-- LSP 诊断和调试功能
-- 添加到 lua/config/functions.lua 或单独加载
-- ==========================================

-- 检查 LSP 状态的命令
vim.api.nvim_create_user_command("LspDebug", function()
  print("=== LSP 调试信息 ===\n")

  -- 1. 检查当前 buffer 的 LSP 客户端
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  print("当前 buffer 的 LSP 客户端: " .. #clients .. " 个")
  for _, client in ipairs(clients) do
    print("  ✓ " .. client.name .. " (ID: " .. client.id .. ")")
  end

  if #clients == 0 then
    print("  ✗ 没有 LSP 客户端附加到当前 buffer")
    print("  提示: 确保文件类型正确，且 LSP 服务器已安装")
  end

  -- 2. 检查文件类型
  local ft = vim.bo.filetype
  print("\n当前文件类型: " .. (ft ~= "" and ft or "未设置"))

  -- 3. 检查快捷键
  print("\n检查快捷键 ,jd:")
  local maps = vim.api.nvim_buf_get_keymap(0, 'n')
  local found = false
  for _, map in ipairs(maps) do
    if map.lhs == ",jd" then
      found = true
      print("  ✓ 已映射")
      if map.callback then
        print("    类型: callback 函数")
      elseif map.rhs then
        print("    映射到: " .. map.rhs)
      end
    end
  end
  if not found then
    print("  ✗ 未找到映射")
    print("  提示: LSP 可能未附加，或 on_attach 未执行")
  end

  -- 4. 建议
  print("\n=== 故障排除步骤 ===")
  print("1. 运行 :LspInfo 查看详细信息")
  print("2. 运行 :Mason 检查 LSP 服务器安装状态")
  print("3. 重启 LSP: :LspRestart")
  print("4. 检查日志: :lua vim.cmd('edit ' .. vim.lsp.get_log_path())")
  print("5. 手动启动: :LspStart pyright")
end, {})

-- 快捷键：<leader>ld 运行诊断
vim.keymap.set("n", "<leader>ld", "<cmd>LspDebug<cr>", { desc = "LSP Debug Info" })

print("✓ LSP 调试功能已加载。运行 :LspDebug 或按 ,ld 查看诊断信息")
