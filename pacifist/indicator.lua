local kills = StatsBiomeGetValue("enemies_killed")
if tonumber( kills ) > 0 then
    Gui = Gui or GuiCreate()
    GuiStartFrame(Gui)
    local message = table.concat{"PACIFISM BROKEN! KILLS: ", kills}
    local screen_width, screen_height = GuiGetScreenDimensions(Gui)
    local text_width, text_height = GuiGetTextDimensions(Gui, message)
    GuiOptionsAddForNextWidget(Gui, 25)
    GuiColorSetForNextWidget(Gui, 0.9, 0.4, 0.4, 0.9)
    GuiText(Gui, (screen_width - text_width) / 2, 5, message)
end