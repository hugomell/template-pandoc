local function code_block_info(elem)
    local name = nil
    local code_block_text = nil
    elem = elem:walk{
        Span = function (span)
            if span.attributes["file"] ~= nil then
              name = pandoc.Str("file: " .. span.attributes["file"])
              return {}
            end
            if span.identifier ~= nil then
              name = pandoc.Str("«" .. span.identifier .. "»")
              return {}
            end
        end,
        CodeBlock = function (block)
            code_block_text = pandoc.CodeBlock(block.text,
                                               {class = block.classes[1]})
            return {}
        end
    }
    local t = {}
    t["name"] = name
    t["content"] = code_block_text
    return t
end

function Div (elem)
    if elem.classes[1] ~= "named-cbl" then
        return
    end
    local info = code_block_info(elem)
    return pandoc.Div({ pandoc.Div({ info.name }, {class = "code-block-title"})
                          , info.content
                      }, { class="named-code-block" })
end
