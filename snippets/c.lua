-- ==========================================
-- C 语言代码片段
-- ==========================================

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- ==========================================
  -- 预处理器
  -- ==========================================

  -- #include
  s("inc", fmt('#include <{}>', { i(1, "stdio.h") })),

  -- #include "" (local)
  s("incl", fmt('#include "{}"', { i(1, "header.h") })),

  -- #define
  s("def", fmt('#define {} {}', { i(1, "NAME"), i(2, "value") })),

  -- #ifndef header guard
  s("guard", fmt([[
#ifndef {}
#define {}

{}

#endif // {}
  ]], {
    i(1, "HEADER_H"),
    f(function(args)
      return args[1][1]
    end, { 1 }),
    i(2),
    f(function(args)
      return args[1][1]
    end, { 1 }),
  })),

  -- ==========================================
  -- 控制结构
  -- ==========================================

  -- if
  s("if", fmt([[
if ({}) {{
    {}
}}
  ]], { i(1, "condition"), i(2) })),

  -- else
  s("else", fmt([[
else {{
    {}
}}
  ]], { i(1) })),

  -- else if
  s("elif", fmt([[
else if ({}) {{
    {}
}}
  ]], { i(1, "condition"), i(2) })),

  -- for
  s("for", fmt([[
for ({}) {{
    {}
}}
  ]], { i(1, "int i = 0; i < n; i++"), i(2) })),

  -- while
  s("while", fmt([[
while ({}) {{
    {}
}}
  ]], { i(1, "condition"), i(2) })),

  -- do-while
  s("do", fmt([[
do {{
    {}
}} while ({});
  ]], { i(1), i(2, "condition") })),

  -- switch
  s("switch", fmt([[
switch ({}) {{
    case {}:
        {}
        break;
    default:
        {}
        break;
}}
  ]], { i(1, "expression"), i(2, "value"), i(3), i(4) })),

  -- ==========================================
  -- 函数
  -- ==========================================

  -- main function
  s("main", fmt([[
int main(int argc, char *argv[]) {{
    {}
    return 0;
}}
  ]], { i(1) })),

  -- function
  s("func", fmt([[
{} {}({}) {{
    {}
}}
  ]], { i(1, "void"), i(2, "function_name"), i(3, "void"), i(4) })),

  -- ==========================================
  -- 结构体
  -- ==========================================

  -- struct
  s("struct", fmt([[
struct {} {{
    {}
}};
  ]], { i(1, "name"), i(2) })),

  -- typedef struct
  s("tds", fmt([[
typedef struct {{
    {}
}} {};
  ]], { i(1), i(2, "name") })),

  -- ==========================================
  -- 内存管理
  -- ==========================================

  -- malloc
  s("mal", fmt('({} *)malloc(sizeof({}) * {})', { i(1, "type"), i(2, "type"), i(3, "count") })),

  -- free
  s("free", fmt([[
free({});
{} = NULL;
  ]], { i(1, "ptr"), f(function(args)
    return args[1][1]
  end, { 1 }) })),

  -- ==========================================
  -- 输入输出
  -- ==========================================

  -- printf
  s("printf", fmt('printf("{}\\n", {});', { i(1, "%d"), i(2) })),

  -- scanf
  s("scanf", fmt('scanf("{}", {});', { i(1, "%d"), i(2, "&var") })),

  -- fprintf
  s("fprintf", fmt('fprintf({}, "{}\\n", {});', { i(1, "stderr"), i(2), i(3) })),
}
