--[[
类似相册展示的容器
]]

local CellList = class("CellList", app.V, cc.TableViewCell)

function CellList:ctor (cellClass, size,  cellWidth, cellHeight, gap)

    CellList.super.ctor(self)

    self.clickSignal = app.S.new()
    self.size = size
    for i=1, size do
        local cell = cellClass.new()

        panel = ccui.Layout:create()
        panel.idx = size * self:getIdx() + i
        panel:addChild(cell)
        cell:setTag(1)
        self:addChild(panel)
        panel.index = i
        panel:setContentSize(cc.size(cellWidth, 200))
        panel:setTouchEnabled(true)
        panel:setSwallowTouches(false)

        local clicked
        panel:addTouchEventListener(function(sender, eventType)

            if eventType == ccui.TouchEventType.began then
                clicked = true
            elseif eventType == ccui.TouchEventType.moved then
                clicked = false
                -- print("moved...")

            elseif eventType == ccui.TouchEventType.ended then
                -- print("clicked:", clicked)
                if clicked then
                    self.index = self:getIdx() * size + sender.index
                    self.clickSignal:fire(self.index, sender:getChildByTag(1))
                end
            elseif eventType == ccui.TouchEventType.canceled then
                print("ccui.TouchEventType.canceled.")
                clicked = false
            end

            -- if  then
            --
            --     self.index = self:getIdx() * size + sender.index
            --     self.clickSignal:fire(self.index, sender:getChildByTag(1))
            -- end
        end)
        panel:setTag(i)
        panel:setPositionX((i- 1) * cellWidth + gap)
    end
end

function CellList:getIndex()
    return self.index
end

function CellList:render(data)
    for i = 1, self.size  do
        local p = self:getChildByTag(i)
        local cell = p:getChildByTag(1)
        if data[i] then
            cell:render(data[i])
            cell:setVisible(true)
        else cell:setVisible(false) end
    end
end

function CellList:onExit ()
    self.clickSignal:clearAll()
end



local UICollectView = class("UICollectView", app.V)

--[[
self.collect = app.widgets.UICollectView.new({
    ["x"] = 20,
    ["y"] = 0,
    ["width"] = 540,
    ["height"] = 600,
    ["cellWidth"] = 120,
    ["cellHeight"] = 200,
    ["p"] = self.skin,
    ["tag"] = 10,
    ["data"] = data,
    ["size"] = 4, --一排几个间距
    ["gap"] = 20, -- 每个cell的间距
    ["cellClass"] = app.goods.GoodsCell
    ["onCellClicked"] = function(idx, cell) end
})
]]
function UICollectView:ctor(params)


    local tableView = params.p:getChildByTag(params.tag)

    local function numberOfCellsInTableView(tableView)
        local itemNum = #params.data
        local num = math.floor(itemNum/params.size)
        if itemNum%params.size ~= 0 then num = num + 1 end
        return num
    end

    local function cellSizeForTable(tableView,idx)
        return params.cellHeight, params.width
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        if nil == cell then
            cell = CellList.new(params.cellClass, params.size, params.cellWidth, params.cellHeight ,params.gap)
        end

        cell.clickSignal:add(function  (idx, item)
            if params.onCellClicked then
                params.onCellClicked(idx, item)
            end
        end)

        local data = {}
        local start = idx * params.size + 1
        for i = start, params.size + start - 1 do
            if params.data[i] then
                table.insert(data, params.data[i])
            end
        end

        if cell.render then cell:render(data) end

        return cell
    end

    if not tableView then
        tableView = cc.TableView:create(cc.size(params.width, params.height))
        tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        if params.isCenter then
            tableView:setPosition(qy.winSize.width/2 - params.width/2,params.y)
        else
            tableView:setPosition(params.x,params.y)
        end
        params.p:addChild(tableView, 1, params.tag)
    end

    local function tableCellTouched(tableView, cell)
        if params.onCellClicked then
            params.onCellClicked(tableView, cell)
        end
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    --tableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    --tableView:setDelegate()

    tableView:reloadData()

    self.tableView = tableView

end

function UICollectView:onExit()

end

function UICollectView:reloadData()
    self.tableView:reloadData()
end

return UICollectView
