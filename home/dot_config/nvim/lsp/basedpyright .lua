return {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  },
  settings = {
    basedpyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
      analysis = {
        autoFormatStrings = true,
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "standard",
      },
      -- https://detachhead.github.io/basedpyright/#/configuration?id=type-check-diagnostics-settings
      -- Severity level can be boolean or a string value of "none", "warning", "information", or "error".
      diagnosticSeverityOverrides = {
        -- https://github.com/DetachHead/basedpyright/issues/168
        reportMissingSuperCall = false,
        reportUnusedImport = "warning",
        reportUnnecessaryIsInstance = "warning",
        reportImplicitStringConcatenation = "warning",
        analyzeUnannotatedFunctions = false,
        deprecateTypingAliases = true,
        reportPropertyTypeMismatch = "warning",
        reportMissingImports = false, -- ruff handles this
        reportImportCycles = "error",
        reportConstantRedefinition = "error",
        reportUndefinedVariable = false, -- ruff handles this with F822
        reportUnusedVariable = false, -- let ruff handle this
        reportAssertAlwaysTrue = "error",
        reportInconsistentOverload = "warning",
        reportInvalidTypeArguments = "warning",
        reportNoOverloadImplementation = "warning",
        reportOptionalSubscript = "warning",
        reportOptionalIterable = "warning",
        reportUntypedNamedTuple = "warning",
        reportPrivateUsage = "warning",
        reportTypeCommentUsage = "warning", -- type comments are deprecated since Python 3.6
        reportDeprecated = "warning",
        reportInconsistentConstructor = "error",
        reportUnnecessaryCast = "warning",
        reportUntypedFunctionDecorator = "information",
        reportUnnecessaryTypeIgnoreComment = "information",
        -- Based options (not available in regular pyright)
        reportUnreachable = "warning",
        reportAny = true,
        reportIgnoreCommentWithoutRule = "warning",
        reportImplicitRelativeImport = "error",
        reportInvalidCast = "warning",
        reportUnsafeMultipleInheritance = "warning",
      },
    },
  },
}
