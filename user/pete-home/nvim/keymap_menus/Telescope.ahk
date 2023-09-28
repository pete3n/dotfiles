return function()
    return {
        ["NVIM: Telescope"] = {
    {
    modifiers = {""},
    keys = {
['Space fh']="Help tags",
['Space fg']="Live grep",
['Space Space ']="Recent files",
['Space ps']="Grep cmdline",
    }
    },
    {
    modifiers = {"Alt"},
    keys = {
['C-G']="Git files",
['C-P']="File search",
    }
    },
    }
}
end
