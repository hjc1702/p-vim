-- Python 文件类型专用配置
-- 确保 LSP 总是启动

-- 检查是否已有客户端附加
local clients = vim.lsp.get_clients({ bufnr = 0 })
if #clients == 0 then
  -- 延迟启动，确保 LSP 配置已加载
  vim.defer_fn(function()
    vim.cmd("silent! LspStart pyright")
  end, 200)
end
