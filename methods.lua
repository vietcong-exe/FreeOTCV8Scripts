local methods = {
      session = "",
    _methods = {
        ["item"] = modules._G.Item,
        ["tile"] = modules._G.Tile,
        ["thing"] = modules._G.Thing,
        ["player"] = modules._G.Player,
        ["creature"] = modules._G.Creature,
    },
};
methods.ui = setupUI([[
MainWindow
  size: 300 250
  !text: tr("UzumarTayhero")
  TextList
    id:list
    anchors.top:parent.top
    anchors.left:parent.left
    anchors.right: parent.right
    margin-right: 15
    layout: verticalBox
    size: 100 130
    vertical-scrollbar:scroll

  VerticalScrollBar
    id:scroll
    anchors.left: prev.right
    anchors.top:prev.top
    anchors.bottom:prev.bottom
    step: 10

  Button
    id: back
    anchors.bottom:parent.bottom
    margin-bottom: 20
    anchors.left:parent.left
    text: back
    width: 130

  Button
    id: next
    anchors.bottom:parent.bottom
    margin-bottom: 20
    anchors.right:parent.right
    anchors.left:back.right
    text: next

  Button
    id:close
    text:close
    anchors.bottom:parent.bottom
    anchors.left: parent.left
    anchors.right:parent.right
    @onClick: self:getParent():hide()

  TextEdit
    id:text
    anchors.bottom:back.top
    anchors.left:parent.left
    anchors.right:parent.right
    color: white

]], g_ui.getRootWidget())
methods.ui:hide();
methods.entry = [[
Label
  text-align: left
  background-color: alpha
  focusable:true
  $focus:
    background-color:#00000055
]]

methods.refreshList = function(order)
    local path = methods._methods[order] or methods._methods
    local list = methods.ui.list
    list:destroyChildren();
    for key, value in pairs(path) do
        local label = g_ui.loadUIFromString(methods.entry, list);
        label:setId(key)
        if key:find("on") then label:destroy(); end
        label.onDoubleClick = function(self)
            if methods._methods[key] then
                methods.session = key
                methods.refreshList(key)
            else
                g_window.setClipboardText(label:getText());
            end
        end
        if methods.session:len() > 0 then
            local labelText = {methods.session, "white", ":", "white", key, "orange", "()", "white"};
            methods.focusWidget(label)
            label:setColoredText(labelText)
        else
            label:setText(key)
        end
    end
    list:focusChild(list:getFirstChild())
end
methods.refreshList()
methods.ui.back.onClick = function(self)
    methods.session = ""
    methods.refreshList();
end

methods.ui.back.onClick = function(self)
    methods.session = "";
    local list = methods.ui.list;
    local focusChild = list:getFocusedChild();
    methods.ui.text:clearText();
    methods.refreshList(focusChild:getText());
end

methods.ui.next.onClick = function(self)
    local list = methods.ui.list;
    local focusChild = list:getFocusedChild();
    focusChild.onDoubleClick();
end

methods.focusWidget = function(child)
    child.onFocusChange = function(self, focus, b)
        if focus then
            methods.ui.text:setText(self:getText());
        end
    end
end

UI.Button("Show methods", function()
    local ui = methods.ui;
    local visible = ui:isVisible();
    if not visible then
        ui:show();
        ui:raise();
        ui:focus();
    else
        ui:hide();
    end
end)
