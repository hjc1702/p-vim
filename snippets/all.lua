-- ==========================================
-- 通用代码片段（所有语言）
-- ==========================================

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- ==========================================
  -- 日期和时间
  -- ==========================================

  -- 当前日期（YYYY-MM-DD）
  s("date", f(function()
    return os.date("%Y-%m-%d")
  end)),

  -- 当前时间（HH:MM:SS）
  s("time", f(function()
    return os.date("%H:%M:%S")
  end)),

  -- 当前日期时间
  s("datetime", f(function()
    return os.date("%Y-%m-%d %H:%M:%S")
  end)),

  -- ==========================================
  -- 注释
  -- ==========================================

  -- TODO 注释
  s("todo", fmt("TODO: {}", { i(1) })),

  -- FIXME 注释
  s("fixme", fmt("FIXME: {}", { i(1) })),

  -- NOTE 注释
  s("note", fmt("NOTE: {}", { i(1) })),

  -- HACK 注释
  s("hack", fmt("HACK: {}", { i(1) })),

  -- XXX 注释
  s("xxx", fmt("XXX: {}", { i(1) })),

  -- ==========================================
  -- 文件头
  -- ==========================================

  s("author", fmt([[
Author: {}
Email: {}
Date: {}
  ]], {
    i(1, "Your Name"),
    i(2, "your@email.com"),
    f(function()
      return os.date("%Y-%m-%d")
    end),
  })),

  -- ==========================================
  -- 常用占位符
  -- ==========================================

  s("lorem", t("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")),
}
