local _, core = ...


local function toggle_button_value(button_type, val)
  if button_type == core.ALERT then
    return core.set_alert(val)
  elseif button_type == core.EMOTE then
    return core.set_emote(val)
  elseif button_type == core.GROUP then
    return core.set_group_messages(val)
  end
end


local uniquealyzer = 1;
local function create_check_button(parent, x_loc, y_loc, displayname, button_type)
  uniquealyzer = uniquealyzer + 1
  local check_button = CreateFrame("CheckButton", "my_addon_checkbutton_0" .. uniquealyzer, parent, "ChatConfigCheckButtonTemplate")
  check_button:SetPoint("TOP", x_loc, y_loc)
  check_button.text = check_button:CreateFontString(nil, "OVERLAY")
  check_button.text:SetFont("Fonts\\FRIZQT__.ttf", 10, "OUTLINE")
  check_button.text:SetText(displayname)
  check_button.text:SetPoint("LEFT", 25, 0)

  local is_enabled = false
  if button_type == core.ALERT then
    is_enabled = core.get_alert()
  elseif button_type == core.EMOTE then
    is_enabled = core.get_emote()
  elseif button_type == core.GROUP then
    is_enabled = core.get_group_messages()
  end
  check_button.text:SetTextColor(1,1,1,.5) -- grey default

  if is_enabled then
    check_button.text:SetTextColor(1,1,1,1)
    check_button:SetChecked(true)
  end

  return check_button;
end


local function toggle_check_button(check_button, button_type)
  if check_button:GetChecked() then
    check_button.text:SetTextColor(1,1,1,1)  -- white
    toggle_button_value(button_type, true)
  else
    check_button.text:SetTextColor(1,1,1,.5) -- grey
    toggle_button_value(button_type, false)
  end
end


local function create_settings_frame()
  local settings_frame = CreateFrame("FRAME")
  settings_frame.name = "SK_FRAME"
  settings_frame:SetSize(175, 100); -- width, height
  settings_frame:SetPoint("CENTER", UIParent, "CENTER")
  settings_frame:SetBackdrop(
    {
      bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
      edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
      tile = true,
      tileSize = 5,
      edgeSize = 2
    }
  )
  settings_frame:SetBackdropColor(0, 0, 0, 0.8)
  settings_frame:SetBackdropBorderColor(0, 0, 0, 0.8)
  settings_frame:SetMovable(true)
  settings_frame:SetClampedToScreen(true)
  settings_frame:SetScript(
    "OnMouseDown",
    function(self, button)
      if button == "LeftButton" then
        self:StartMoving()
      end
    end
  )
  settings_frame:SetScript("OnMouseUp", settings_frame.StopMovingOrSizing)
  settings_frame.text = settings_frame:CreateFontString(nil, "OVERLAY")
  settings_frame.text:SetFont("Fonts\\MORPHEUS.ttf", 13, "OUTLINE")
  settings_frame.text:SetPoint("TOP", 0, -5)
  settings_frame.text:SetText("SoulKeeper Settings")
  settings_frame.text:SetTextColor(.9,.1,.1)

  local closeButton = CreateFrame("Button", nil, settings_frame, "UIPanelCloseButton")
  closeButton:SetPoint("TOPRIGHT", 0, 0)
  closeButton:SetSize(20,20)

  local alert_check_button = create_check_button(settings_frame, -(settings_frame:GetWidth()/3), -(settings_frame:GetHeight()/4), "Alerts", core.ALERT);
  alert_check_button.tooltip = "Toggle printing private alerts to chat. \nE.g. what soul was used for the cast spell."
  alert_check_button:SetScript("OnClick", 
    function()
      toggle_check_button(alert_check_button, core.ALERT)
    end
  );

  local emote_check_button = create_check_button(settings_frame, -(settings_frame:GetWidth()/3), -(settings_frame:GetHeight()/4) - 20, "Emotes", core.EMOTE);
  emote_check_button.tooltip = "Toggle sending Soulstone/Summon messages to raid/party."
  emote_check_button:SetScript("OnClick", 
    function()
      toggle_check_button(emote_check_button, core.EMOTE)
    end
  );

  local group_check_button = create_check_button(settings_frame, -(settings_frame:GetWidth()/3), -(settings_frame:GetHeight()/4) - 40, "Group Messaging", core.GROUP);
  group_check_button.tooltip = "Toggle displaying emotes when consuming player souls."
  group_check_button:SetScript("OnClick", 
    function()
      toggle_check_button(group_check_button, core.GROUP)
    end
  );
end
core.create_settings_frame = create_settings_frame

-- TODO: If already shown dont open another window.. test by typing /sk multiple times
-- TODO: Add reset button || add a CLI argument? .. maybe with popup confirming decision
