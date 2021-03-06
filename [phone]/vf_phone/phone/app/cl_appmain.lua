local selectedItem = 4

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if Phone.Visible and not Phone.InApp then
            for i = 0, 8 do
                BeginScaleformMovieMethod(Phone.Scaleform, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(1)
                ScaleformMovieMethodAddParamInt(i)
                if Apps[i + 1] and Apps[i + 1].Icon then
                    ScaleformMovieMethodAddParamInt(Apps[i + 1].Icon)
                else
                    ScaleformMovieMethodAddParamInt(3)
                end
                EndScaleformMovieMethod()
            end

            BeginScaleformMovieMethod(Phone.Scaleform, "DISPLAY_VIEW")
            ScaleformMovieMethodAddParamInt(1)
            ScaleformMovieMethodAddParamInt(selectedItem)
            EndScaleformMovieMethod()

            BeginScaleformMovieMethod(Phone.Scaleform, "SET_HEADER")
            if Apps[selectedItem + 1] and Apps[selectedItem + 1].Name then
                BeginTextCommandScaleformString("STRING")
                AddTextComponentString(Apps[selectedItem + 1].Name)
                EndTextCommandScaleformString()
            else
                BeginTextCommandScaleformString("STRING")
                AddTextComponentString("")
                EndTextCommandScaleformString()
            end
            EndScaleformMovieMethod()

            local navigated = true
            if IsControlJustPressed(3, 172) then -- INPUT_CELLPHONE_UP (arrow up)
                selectedItem = selectedItem - 3
                if selectedItem < 0 then
                    selectedItem = 9 + selectedItem
                end
            elseif IsControlJustPressed(3, 173) then -- INPUT_CELLPHONE_DOWN (arrow down)
                selectedItem = selectedItem + 3
                if selectedItem > 8 then
                    selectedItem = selectedItem - 9
                end
            elseif IsControlJustPressed(3, 175) then -- INPUT_CELLPHONE_RIGHT (arrow right)
                selectedItem = selectedItem + 1
                if selectedItem > 8 then
                    selectedItem = 0
                end
            elseif IsControlJustPressed(3, 174) then -- INPUT_CELLPHONE_LEFT (arrow left)
                selectedItem = selectedItem - 1
                if selectedItem < 0 then
                    selectedItem = 8
                end
            else
                if IsControlJustPressed(3, 176) then -- INPUT_CELLPHONE_SELECT (enter / lmb)
                    Wait(0) -- Workaround to next app from registering enter press too
                    Apps.Start(selectedItem + 1)
                elseif IsControlJustPressed(3, 177) then -- INPUT_CELLPHONE_CANCEL (backspace / esc / rmb)
                    Phone.Kill()
                end
                navigated = false
            end
            if navigated then
                PlaySoundFrontend(-1, "Menu_Navigate", "Phone_SoundSet_Default")
            end
        end
    end
end)