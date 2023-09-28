local chatgpt = {}

function chatgpt.setup()
    api_key_cmd = os.getenv("OPENAI_API_KEY")
    predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/pete3n/neovim_config/master/lua/core/plugin_config/chatgpt/chat_prompts.csv"
end
return chatgpt
