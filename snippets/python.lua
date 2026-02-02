-- ==========================================
-- Python 代码片段（LuaSnip 格式）
-- 从 UltiSnips 迁移常用片段
-- ==========================================

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- ==========================================
  -- 文件头和编码
  -- ==========================================

  -- # coding: utf-8
  s("code", {
    t("# coding: utf-8"),
  }),

  -- if __name__ == '__main__'
  s("main", fmt([[
if __name__ == '__main__':
    {}
  ]], { i(1) })),

  -- ==========================================
  -- Import 语句
  -- ==========================================

  -- import
  s("im", fmt("import {}", { i(1) })),

  s("imp", fmt([[
import {}
{}
  ]], { i(1, "module"), i(2) })),

  -- from ... import ...
  s("from", fmt("from {} import {}", { i(1), i(2) })),

  s("fim", fmt("from {} import {}", { i(1), i(2) })),

  -- ==========================================
  -- 单字符快捷方式
  -- ==========================================

  -- True/False/None
  s("t", t("True")),
  s("f", t("False")),
  s("n", t("None")),

  -- return
  s("r", fmt("return {}", { i(1) })),

  -- self.
  s("s", fmt("self.{}", { i(1) })),

  -- print
  s("p", fmt("print({})", { i(1) })),

  s("pr", fmt('print("{}")', { i(1) })),

  -- repr
  s("rep", fmt("repr({})", { i(1) })),

  -- assert
  s("a", fmt("assert {}", { i(1) })),

  -- isinstance
  s("isi", fmt("isinstance({}, {})", { i(1), i(2) })),

  -- ==========================================
  -- 控制结构
  -- ==========================================

  -- else
  s("el", fmt([[
else:
    {}
  ]], { i(1, "# TODO") })),

  -- elif
  s("ei", fmt([[
elif {}:
    {}
  ]], { i(1), i(2) })),

  -- while
  s("while", fmt([[
while {}:
    {}
  ]], { i(1, "expression"), i(2, "# TODO") })),

  -- for i in
  s("for", fmt([[
for {} in {}:
    {}
  ]], { i(1, "item"), i(2, "iterable"), i(3, "pass") })),

  -- if
  s("if", fmt([[
if {}:
    {}
  ]], { i(1), i(2) })),

  -- try-except
  s("try", fmt([[
try:
    {}
except {}:
    {}
  ]], { i(1), i(2, "Exception"), i(3, "pass") })),

  -- with
  s("with", fmt([[
with {} as {}:
    {}
  ]], { i(1), i(2, "f"), i(3) })),

  -- ==========================================
  -- 函数和类
  -- ==========================================

  -- def
  s("def", fmt([[
def {}({}):
    {}
  ]], { i(1, "function_name"), i(2), i(3, "pass") })),

  -- defs (self method)
  s("defs", fmt([[
def {}(self, {}):
    """{}"""
    {}
  ]], { i(1, "fname"), i(2, "**kwargs"), i(3, "docstring"), i(4, "pass") })),

  -- __init__
  s("init", fmt([[
def __init__(self, {}):
    {}
  ]], { i(1, "args"), i(2) })),

  -- class
  s("class", fmt([[
class {}({}):
    """{}"""

    def __init__(self, {}):
        {}
  ]], { i(1, "ClassName"), i(2, "object"), i(3, "docstring"), i(4), i(5, "pass") })),

  -- ==========================================
  -- 列表推导式
  -- ==========================================

  -- [i for i in l]
  s("fin", fmt("[{} for {} in {}]", { i(1, "item"), i(2, "item"), i(3) })),

  -- [i for i in l if i]
  s("finif", fmt("[{} for {} in {} if {}]", { i(1, "item"), i(2, "item"), i(3), i(4) })),

  -- ==========================================
  -- 其他常用
  -- ==========================================

  -- TODO 注释
  s("td", fmt("TODO: {}", { i(1) })),

  -- FIXME 注释
  s("fix", fmt("FIXME: {}", { i(1) })),

  -- 注释
  s("#", fmt("# {}", { i(1) })),

  -- raise
  s("rai", fmt("raise {}", { i(1) })),

  -- traceback
  s("tr", t("import traceback; traceback.print_exc()")),

  -- __xxx__
  s("_", fmt("__{}__", { i(1, "init") })),

  -- docstring
  s("doc", fmt([[
"""
{}
"""
  ]], { i(1, "description") })),

  -- ==========================================
  -- Lambda
  -- ==========================================

  s("lam", fmt("lambda {}: {}", { i(1, "x"), i(2) })),

  s("lambda", fmt("lambda {}: {}", { i(1, "x"), i(2) })),
}
