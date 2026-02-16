(import-macros {: setup : expect : in-sub-nvim} :test.macros)
(setup)

(fn p [x] (.. (vim.fn.stdpath :config) x))
(local {: cache-prefix} (require :hotpot.api.cache))

;; Test that lsp/ files are compiled to cache but not executed.
;; Neovim's native lsp/ loading will execute them on demand.
(local lsp-fnl-path (p :/lsp/test_server.fnl))
(local lsp-lua-path
       (.. (cache-prefix) :/ NVIM_APPNAME :/lsp/test_server.lua))

(write-file lsp-fnl-path "(set _G.lsp_val 42)")

;; _G.lsp_val should NOT be set - lsp files are compiled, not executed
(expect 0 (in-sub-nvim "vim.defer_fn(function() os.exit(_G.lsp_val or 0) end, 50)")
        "lsp/*.fnl compiled but not executed")

;; Test that cache file exists at the module cache path
(expect true (vim.loop.fs_access lsp-lua-path :R) "lsp lua file exists in module cache")

;; Test that lsp/ files are not recompiled when unchanged
(local stat-before (vim.loop.fs_stat lsp-lua-path))
(expect 0 (in-sub-nvim "vim.defer_fn(function() os.exit(_G.lsp_val or 0) end, 50)")
        "lsp/*.fnl not executed on second run")

(local stat-after (vim.loop.fs_stat lsp-lua-path))
(expect true
        (and (= stat-before.mtime.sec stat-after.mtime.sec)
             (= stat-before.mtime.nsec stat-after.mtime.nsec))
        "lsp lua file was not recompiled")

;; Test that files removed from lsp/ are removed from the cache
(vim.loop.fs_unlink lsp-fnl-path)
(expect 0
        (in-sub-nvim "vim.defer_fn(function() os.exit(0) end, 50)")
        "sub-nvim starts after lsp file removed")

(if (not= 1 (vim.fn.has :win32))
    (expect false (vim.loop.fs_access lsp-lua-path :R) "lsp lua file removed"))

;; Test that .lua sibling takes preference over .fnl
(local lsp-fnl-path-2 (p :/lsp/x.fnl))
(local lsp-lua-sibling (p :/lsp/x.lua))
(local lsp-compiled-path
       (.. (cache-prefix) :/ NVIM_APPNAME :/lsp/x.lua))

(write-file lsp-fnl-path-2 "(set _G.lsp_x 99)")
(write-file lsp-lua-sibling "_G.lsp_x = 1")

;; fnl side-effect should not occur when lua sibling exists
(expect 0 (in-sub-nvim "vim.defer_fn(function() os.exit(_G.lsp_x or 0) end, 50)")
        "lsp/*.fnl not executed when lua sibling exists")

(expect false (vim.loop.fs_access lsp-compiled-path :R)
        "fnl never compiled when lua sibling exists")

(exit)
