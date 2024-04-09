surface.CreateFont("font_24", {
    font = "Roboto",
    extended = false,
    size = 30,
    weight = 500,
})

surface.CreateFont("font_40", {
    font = "Roboto", 
    extended = false,
    size = 40,
    weight = 900,
})

surface.CreateFont("font_60", {
    font = "Impact", 
    extended = false,
    size = 60,
    weight = 500,
})

surface.CreateFont("font_18", {
    font = "Roboto", 
    extended = false,
    size = 18,
    weight = 500,
})

local function InitializeAddon()
    local function CreatePanel()
        local dpanelrules = vgui.Create("DFrame")
        dpanelrules:SetSize(450, 600)
        dpanelrules:SetPos(ScrW() / 2 - 225, ScrH() / 2 - 300)
        dpanelrules:MakePopup()
        dpanelrules:SetDraggable(false)
        dpanelrules.Paint = function(self, w, h)
            draw.RoundedBox(10, 0, 0, w, h, Color(30, 30, 30))
        end

        local headerHeight = 40

        local rulesheader = vgui.Create("DPanel", dpanelrules)
        rulesheader:SetSize(dpanelrules:GetWide(), headerHeight)
        rulesheader:SetPos(0, 0)
        rulesheader.Paint = function(self, w, h)
            draw.RoundedBox(1, 0, 0, w, h, Color(0, 132, 255))
            draw.SimpleText((SIMPLERULES.Theme["SERVER-NAME"]), "font_24", 10, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        local headeroutline = vgui.Create("DPanel", dpanelrules)
        headeroutline:SetSize(dpanelrules:GetWide(), 1)
        headeroutline:SetPos(0, 40)
        headeroutline.Paint = function(self, w, h)
            draw.RoundedBox(2, 0, 0, w, h, Color(255, 255, 255, 100))
        end

        local rulesTitleBox = vgui.Create("DPanel", dpanelrules)
        rulesTitleBox:SetSize(dpanelrules:GetWide() - 30, 45) -- Adjust width and initial height as needed
        rulesTitleBox:SetPos(15, headerHeight + 15) -- Adjust position to below the header
        rulesTitleBox.Paint = function(self, w, h)
            draw.RoundedBox(3, 0, 0, w, h, Color(50, 50, 50))
            draw.SimpleText("SERVER CONDUCT RULES", "font_24", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        local rulesTitleBoxOutline = vgui.Create("DPanel", dpanelrules)
        rulesTitleBoxOutline:SetSize(dpanelrules:GetWide() - 30, 1)
        rulesTitleBoxOutline:SetPos(15, 100)
        rulesTitleBoxOutline.Paint = function(self, w, h)
            draw.RoundedBox(3, 0, 0, w, h, Color(0, 132, 255, 100))
        end

        local margin = 15
        local availableHeight = dpanelrules:GetTall() - headerHeight - margin * 7 - rulesTitleBox:GetTall()

        -- Create the inner panel for the scrolling text
        local InnerRulesPanel = vgui.Create("DScrollPanel", dpanelrules)
        InnerRulesPanel:SetSize(dpanelrules:GetWide() - 30, availableHeight)
        InnerRulesPanel:SetPos(15, headerHeight + margin + rulesTitleBox:GetTall() + margin)
        
        -- Customize the appearance of the vertical scrollbar
        local vBar = InnerRulesPanel:GetVBar()
        vBar:SetWide(20)  -- Set the width of the scrollbar
        vBar:SetHideButtons(true)  -- Hide the scroll buttons
        vBar.Paint = function(self, w, h)
            -- Custom scrollbar painting
            draw.RoundedBox(4, 0, 0, w, h, Color(100, 100, 100))
        end
        vBar.btnGrip.Paint = function(self, w, h)
            -- Custom grip painting
            draw.RoundedBox(4, 0, 0, w, h, Color(0, 132, 255))
        end

        local InnerPanelText = (SIMPLERULES.Theme["INSIDE-TEXT"])

            
        InnerPanelText = string.gsub(InnerPanelText, "\n%s*", "\n\n"):gsub("^%s*", "")
            

        local rulesOfConductLabel = vgui.Create("DLabel", InnerRulesPanel)
        rulesOfConductLabel:SetFont("font_24")
        rulesOfConductLabel:SetText(InnerPanelText)
        rulesOfConductLabel:SetWrap(true)
        rulesOfConductLabel:SetAutoStretchVertical(true)
        rulesOfConductLabel:SetContentAlignment(7)
        rulesOfConductLabel:SetTextColor(Color(255, 255, 255))
        rulesOfConductLabel:Dock(FILL)

        -- Adjust the size of the scroll panel to fit the text content
        InnerRulesPanel:GetVBar():SetScroll(0) -- Scroll to the top initially


        local bottombcontainer = vgui.Create("DPanel", dpanelrules)
        bottombcontainer:Dock(BOTTOM)
        bottombcontainer:SetSize(dpanelrules:GetWide(), 50)
        bottombcontainer:DockMargin(5, 5, 5, 5)
        bottombcontainer.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(61, 61, 61))
        end

        local buttonWidth = (bottombcontainer:GetWide() - 45 - 10) / 2 -- Subtracting the margin and the space between buttons

        local acceptConduct = vgui.Create("DButton", bottombcontainer)
        acceptConduct:SetText("Accept Terms")
        acceptConduct:SetTextColor(Color(0, 255, 0))
        acceptConduct:SetSize(buttonWidth, bottombcontainer:GetTall() - 10) -- Subtracting margin from total width
        acceptConduct:Dock(LEFT)
        acceptConduct:DockMargin(5, 5, 5, 5)
        
        local isHovered = false

        acceptConduct.Paint = function (self, w, h)
            if isHovered then
                draw.RoundedBox(4, 0, 0, w, h, Color(0, 132, 255)) -- Change color when hovered
                self:SetTextColor(Color(0, 255, 0)) -- Set text color to red
            else
                draw.RoundedBox(4, 0, 0, w, h, Color(0, 132, 255))
                self:SetTextColor(Color(255, 255, 255)) -- Set text color to white
            end
        end
        acceptConduct.DoClick = function(self)
            dpanelrules:Remove()
        end

        acceptConduct.OnCursorEntered = function(self)
            isHovered = true
        end
        
        acceptConduct.OnCursorExited = function(self)
            isHovered = false
        end

        local isHovered = false

        local denyConduct = vgui.Create("DButton", bottombcontainer)
        denyConduct:SetText("Do Not Accept")
        denyConduct:SetSize(buttonWidth, bottombcontainer:GetTall() - 10) -- Subtracting margin from total width
        denyConduct:Dock(RIGHT)
        denyConduct:DockMargin(5, 5, 5, 5)
        
        denyConduct.Paint = function (self, w, h)
            if isHovered then
                draw.RoundedBox(4, 0, 0, w, h, Color(0, 132, 255)) -- Change color when hovered
                self:SetTextColor(Color(255, 0, 0)) -- Set text color to red
            else
                draw.RoundedBox(4, 0, 0, w, h, Color(0, 132, 255))
                self:SetTextColor(Color(255, 255, 255)) -- Set text color to white
            end
        end
        
        denyConduct.DoClick = function(self)
            net.Start("KickPlayer")
            net.SendToServer()
        end
        
        denyConduct.OnCursorEntered = function(self)
            isHovered = true
        end
        
        denyConduct.OnCursorExited = function(self)
            isHovered = false
        end
        
    end

    -- Delay the creation of the panel to ensure game environment is initialized
    timer.Simple(0.1, CreatePanel)
end

net.Receive("rulesPanelOpen", function()
    InitializeAddon()
end)
