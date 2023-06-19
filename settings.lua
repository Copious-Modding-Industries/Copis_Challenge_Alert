dofile("data/scripts/lib/mod_settings.lua") -- see this file for documentation on some of the features.
dofile("data/scripts/lib/utilities.lua")
local mod_id = "Copis_Cheats"
local in_game = false
mod_settings_version = 1
mod_settings = {
    {
        id = "warning",
        ui_name = "",
        ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
            if in_main_menu then
                GuiLayoutBeginHorizontal(gui, 0, 0, false, 5, 5)
                GuiImage(gui, im_id, 0, 0, "data/ui_gfx/inventory/icon_warning.png", 1, 1, 1)
                GuiColorSetForNextWidget(gui, 0.9, 0.4, 0.4, 0.9)
                GuiText(gui, 0, 2, "Tools are only useable in-game!")
                GuiLayoutEnd(gui)
            end
        end
    },
}

function ModSettingsGuiCount()
    return mod_settings_gui_count(mod_id, mod_settings)
end

-- This function is called to display the settings UI for this mod. Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
function ModSettingsGui(gui, in_main_menu)
    screen_width, screen_height = GuiGetScreenDimensions(gui)
    mod_settings_gui(mod_id, mod_settings, gui, in_main_menu)
    if not in_main_menu and not in_game then
        in_game = true
        mod_settings = {
            {
                category_id = "pacifist",
                ui_name = "Pacifism Tools",
                ui_description = "Tools to help with pacifist runs",
                settings = {
                    {
                        id = "indicator",
                        ui_name = "",
                        ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
                            if not in_main_menu then
                                local player = EntityGetWithTag("player_unit")[1]
                                local cheatcomp = EntityGetFirstComponentIncludingDisabled(player, "LuaComponent", "PacifistIndicator")
                                if cheatcomp ~= nil then
                                    GuiColorSetForNextWidget(gui, 0.4, 0.9, 0.4, 0.8)
                                    local lmb = GuiButton(gui, im_id, mod_setting_group_x_offset, 0, "[Disable Indicator]")
                                    if lmb then
                                        GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_click", GameGetCameraPos())
                                        EntityRemoveComponent(player, cheatcomp)
                                    end
                                else
                                    GuiColorSetForNextWidget(gui, 0.9, 0.4, 0.4, 0.8)
                                    local lmb = GuiButton(gui, im_id, mod_setting_group_x_offset, 0, "[Enable Indicator]")
                                    if lmb then
                                        local cheatcomp_new = EntityAddComponent2(player, "LuaComponent", {
                                            script_source_file = "mods/Copis_Challenge_Alert/pacifist/indicator.lua",
                                            execute_on_added = false,
                                            execute_on_removed = false,
                                            execute_every_n_frame = 1,
                                            execute_times = 0, -- infinite
                                            remove_after_executed = false,
                                            enable_coroutines = false,
                                        })
                                        ComponentAddTag(cheatcomp_new, "PacifistIndicator")
                                    end
                                end
                                GuiTooltip(gui, "Press this button to manage indicator mode.", table.concat{"When your pacifism is broken, you get an alert on-screen!\n", (cheatcomp and "Indicator is currently enabled" or "Indicator is currently disabled")})
                            end
                        end
                    },
                }
            }
        }
    end
end

function ModSettingsUpdate(init_scope)
    local old_version = mod_settings_get_version(mod_id) -- This can be used to migrate some settings between mod versions.
    mod_settings_update(mod_id, mod_settings, init_scope)
end
