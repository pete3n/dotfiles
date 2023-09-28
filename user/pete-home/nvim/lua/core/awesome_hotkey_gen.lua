local config_path = vim.fn.stdpath('config')
local keymap_menus_path = config_path .. "/keymap_menus"

if vim.fn.isdirectory(keymap_menus_path) == 0 then
    vim.fn.mkdir(keymap_menus_path, "p")
end

-- Function to extract modifiers and key from a keymap string
local function extract_modifiers_and_key(keymap_str)
    local modifiers = {}
    local key = keymap_str

    if string.find(key, "<leader>") then
        local leader_key = vim.g.mapleader or "\\"
        key = key:gsub("<leader>", leader_key)
    end

    if string.find(key, " ") then
        key = key:gsub(" ", "Space ")
        return modifiers, key
    end

    local mod_map = {
        ["<C-"] = "Ctrl",
        ["<M-"] = "Alt",
        ["<S-"] = "Shift",
    }

    for mod, replacement in pairs(mod_map) do
        if string.find(key, mod) then
            table.insert(modifiers, replacement)
            key = string.gsub(key, mod, "")
        end
    end

    if table.concat(modifiers, "-"):find("Ctrl") then
        key = key:gsub("^C%-", "")
    end

    key = key:gsub(">$", "")
    key = key:gsub("^%s*(.-)%s*$", "%1")

    return modifiers, key
end

-- Function to generate Awesome hotkeys for the filtered keymaps
function gen_awesome_hk(keymaps, module_name)
    local hotkeys = {}

    for _, map in ipairs(keymaps) do
        local description = map.desc:match(": (.+)$") 
        local modifiers, key = extract_modifiers_and_key(map.lhs)
        local mod_str = table.concat(modifiers, "-")
        
        if not hotkeys[mod_str] then
            hotkeys[mod_str] = {
                modifiers = modifiers,
                keys = {}
            }
        end

        hotkeys[mod_str].keys[key] = description
    end

    local final_format = {}
    for _, mappings in pairs(hotkeys) do
        table.insert(final_format, mappings)
    end

    local file_path = keymap_menus_path .. "/" .. module_name .. ".ahk"
    local file, err = io.open(file_path, "w")

    if not file then
        print("Failed to open keymap menu file:", err)
        return
    end

    local output_str = 'return function()\n'
    output_str = output_str .. '    return {\n'
    output_str = output_str .. '        ["NVIM: ' .. module_name .. '"] = {\n'
    for _, mappings in ipairs(final_format) do
	    output_str = output_str .. "    {\n"
	    output_str = output_str .. "    modifiers = {\"" .. table.concat(mappings.modifiers, "\", \"") .. "\"},\n"
	    output_str = output_str .. "    keys = {\n"
	    for key, description in pairs(mappings.keys) do
	         output_str = output_str .. string.format("['%s']=\"%s\",\n", key, description)
	    end
	    output_str = output_str .. "    }\n"
	    output_str = output_str .. "    },\n"
	end
	output_str = output_str .. "    }\n"
    output_str = output_str .. "}\n"
    output_str = output_str .. 'end\n'

    file:write(output_str)
    file:close()
end

return {
    generate = gen_awesome_hk
}
