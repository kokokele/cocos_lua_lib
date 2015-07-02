--[[
类似相册展示的容器
]]

local CellList = class("CellList", cc.TableViewCell)

function CellList:ctor (cellClass, size,  cellWidth, gap)
    print("CellList:", cellClass, size, gap)
    self.size = size
    for i=1, size do
        local cell = cellClass.new()
        self:addChild(cell)
        cell:setTag(i)
        cell:setPositionX((i- 1) * cellWidth + gap)
    end
end

function CellList:render(data)
    for i=1, self.size  do
        local cell = self:getChildByTag(i)
        if data[i] then
            cell:render(data[i])
            cell:setVisible(true)
        else cell:setVisible(false) end
    end
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
            cell = CellList.new(params.cellClass, params.size, params.cellWidth ,params.gap)
        end

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
        print("tableCellTouched:", tableView, cell)
        if params.onCellClicked then
            params.onCellClicked(tableView, cell)
        end
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)
    tableView:setDelegate()

    tableView:reloadData()

    self.tableView = tableView

end

function UICollectView:reloadData()
    self.tableView:reloadData()
end

return UICollectView
