---------------------------------------------------------------------------
--- NVIM dynamic hotkeys for awful.hotkeys_widget
--
-- @author Pete3n &lt;pete3n@protonmail.com&gt;
-- @submodule awful.hotkeys_popup
---------------------------------------------------------------------------

-- This assumes your nvim config is in ~/.config/nvim
local home = os.getenv("HOME")
local ahk_directory = home .. "/.config/nvim/keymap_menus"

local hotkeys_popup = require("awful.hotkeys_popup.widget")

local nvim_rule_any = {name={"nvim", "NVIM"}}
for group_name, group_data in pairs({
    ["NVIM: motion"] =             { color="#0a5c36", rule_any=nvim_rule_any },
    ["NVIM: command"] =            { color="#cfb80e", rule_any=nvim_rule_any },
    ["NVIM: command (insert)"] =   { color="#870101", rule_any=nvim_rule_any },
    ["NVIM: diff"] =               { color="#870fd6", rule_any=nvim_rule_any },
    ["NVIM: fold"] =               { color="#605969", rule_nay=nvim_rule_any },
    ["NVIM: operator"] =           { color="#9c1170", rule_any=nvim_rule_any },
    ["NVIM: find"] =               { color="#11849c", rule_any=nvim_rule_any },
    ["NVIM: scroll"] =             { color="#d9d3de", rule_any=nvim_rule_any },
}) do
    hotkeys_popup.add_group_rules(group_name, group_data)
end

local nvim_keys = {

    ["NVIM: motion"] = {{
        modifiers = {},
        keys = {
            ['`']="goto mark",
            ['0']='"hard" BOL',
            ['-']="prev line",
            w="next word",
            e="end word",
            ['[']=". misc",
            [']']=". misc",
            ["'"]=". goto mk. BOL",
            b="prev word",
            ["|"]='BOL/goto col',
            ["$"]='EOL',
            ["%"]='goto matching bracket',
            ["^"]='"soft" BOL',
            ["("]='sentence begin',
            [")"]='sentence end',
            ["_"]='"soft" BOL down',
            ["+"]='next line',
            W='next WORD',
            E='end WORD',
            ['{']="paragraph begin",
            ['}']="paragraph end",
            G='EOF/goto line',
            H='move cursor to screen top',
            M='move cursor to screen middle',
            L='move cursor to screen bottom',
            B='prev WORD',
        }
    }, {
        modifiers = {"Ctrl"},
        keys = {
            u="half page up",
            d="half page down",
            b="page up",
            f="page down",
            o="prev mark",
        }
    }},

    ["NVIM: operator"] = {{
        modifiers = {},
        keys = {
            ['=']="auto format",
            y="yank",
            d="delete",
            c="change",
            ["!"]='external filter',
            ['&lt;']='unindent',
            ['&gt;']='indent',
        }
    }},

    ["NVIM: command"] = {{
        modifiers = {},
        keys = {
            ['~']="toggle case",
            q=". record macro",
            r=". replace char",
            u="undo",
            p="paste after",
            gg="go to the top of file",
            gf="open file under cursor",
            x="delete char",
            v="visual mode",
            m=". set mark",
            ['.']="repeat command",
            ["@"]='. play macro',
            ["&amp;"]='repeat :s',
            Q='ex mode',
            Y='yank line',
            U='undo line',
            P='paste before cursor',
            D='delete to EOL',
            J='join lines',
            K='help',
            [':']='ex cmd line',
            ['"']='. register spec',
            ZZ='quit and save',
            ZQ='quit discarding changes',
            X='back-delete',
            V='visual lines selection',
        }
    }, {
        modifiers = {"Ctrl"},
        keys = {
            w=". window operations",
            r="redo",
            ["["]="normal mode",
            a="increase number",
            x="decrease number",
            g="file/cursor info",
            z="suspend",
            c="cancel/normal mode",
            v="visual block selection",
        }
    }},

    ["NVIM: command (insert)"] = {{
        modifiers = {},
        keys = {
            i="insert mode",
            o="open below",
            a="append",
            s="subst char",
            R='replace mode',
            I='insert at BOL',
            O='open above',
            A='append at EOL',
            S='subst line',
            C='change to EOL',
        }
    }},

    ["NVIM: find"] = {{
        modifiers = {},
        keys = {
            [';']="repeat t/T/f/F",
            [',']="reverse t/T/f/F",
            ['/']=". find",
            ['?']='. reverse find',
            n="next search match",
            N='prev search match',
            f=". find char",
            F='. reverse find char',
            t=". 'till char",
            T=". reverse 'till char",
            ["*"]='find word under cursor',
            ["#"]='reverse find under cursor',
        }
    }},

    ["NVIM: scroll"] = {{
        modifiers = {},
        keys = {
            zt="scroll cursor to the top",
            zz="scroll cursor to the center",
            zb="scroll cursor to the bottom",
        }
    },{
        modifiers = {"Ctrl"},
        keys = {
            e="scroll line up",
            y="scroll line down",
        }
    }},

    ["NVIM: fold"] = {{
        modifiers = {},
        keys = {
            za="toggle",
            zc="close",
            zo="open",
            zA="toggle recursive",
            zC="close recursive",
            zO="open recursive",
            zm="close all one level",
            zr="open all one level",
            zM="close all",
            zR="open all",
        }
    }},

    ["NVIM: diff"] = {{
        modifiers = {},
        keys = {
            ["do"]="diff obtain",
            ["dp"]="diff put",
            ["]c"]="jump next",
            ["[c"]="jump previous",
        }
    }},
}

--
-- Function to list all files in a directory (UNIX-based implementation)
local function list_files(directory)
    local files = {}
    local p = io.popen('ls "' .. directory .. '"')  -- Open directory to look for files
    for file in p:lines() do                         -- Loop through all files
        table.insert(files, file)
    end
    p:close()
    return files
end

local function load_ahk_files()
    for _, file in ipairs(list_files(ahk_directory)) do
        -- Check if the file has the .ahk extension

        if file:match("%.ahk$") then
            local filepath = ahk_directory .. '/' .. file
            local f = assert(io.open(filepath, "r"))
            local content = f:read("*all")
            f:close()

            -- Load the content as Lua code and execute it
            local func = assert(loadstring(content))
            local ahk_function = func()
            local ahk_table = ahk_function()

            -- Merge the new table into nvim_keys
            for k, v in pairs(ahk_table) do
                for inner_key, inner_value in pairs(v) do
                    if type(inner_value) == "table" then
                        for t_key, t_value in pairs(inner_value) do
                        end
                    end
                end
                nvim_keys[k] = v
            end

            -- Dynamically add the group rules
            for group_name, _ in pairs(ahk_table) do
                hotkeys_popup.add_group_rules(group_name, { color="#659FFF", rule_any=nvim_rule_any })
            end
        end
    end
end

-- load_ahk_files() 
hotkeys_popup.add_hotkeys(nvim_keys)
