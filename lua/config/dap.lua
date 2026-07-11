local dap = require("dap")
local dapui = require("dapui")

local mason_registry = require("mason-registry")
local js_debug_pkg = "js-debug-adapter"

if not mason_registry.is_installed(js_debug_pkg) then
  mason_registry.get_package(js_debug_pkg):install()
end

local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

dap.adapters["pwa-node"] = {
  type = "server",
  host = "127.0.0.1",
  port = "${port}",
  executable = {
    command = "node",
    args = { js_debug_path, "${port}" },
  },
}

for _, filetype in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
  dap.configurations[filetype] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Rodar arquivo atual",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Anexar a processo Node existente",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
    },
  }
end

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticWarn" })

local map = vim.keymap.set
map("n", "<F5>", dap.continue, { desc = "Debug: continuar/iniciar" })
map("n", "<F10>", dap.step_over, { desc = "Debug: step over" })
map("n", "<F11>", dap.step_into, { desc = "Debug: step into" })
map("n", "<F12>", dap.step_out, { desc = "Debug: step out" })
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: toggle breakpoint" })
map("n", "<leader>du", dapui.toggle, { desc = "Debug: toggle UI" })
