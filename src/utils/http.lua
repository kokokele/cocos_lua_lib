--[[
    说明: Http请求库

    TODO: 实现队列功能, 加入协程

    usage:
        qy.Http.new(qy.Http.Request.new(params[, qy.Http.GET | qy.Http.POST]):send(function(response)
            print(response.code, response.data)
        end))
]]



local Http = class("Http")

-- 请求方法常量
Http.GET = "GET"
Http.POST = "POST"

Http.Request = class("HttpRequest")
Http.Response = class("HttpResponse")

function Http:ctor(request)
    self.request = request
end

function Http:send(callback, isHideLoading)

    if app.config.DEBUG then
        print("url: " .. self.request.url:toStr())
        print("params: " .. app.Json.encode(self.request.params))
    end

    local xhr = cc.XMLHttpRequest:new()

    local function onReadyStateChange()
        if app.config.DEBUG then
            print("http response: ")
            print("status: ", xhr.status)
            print("返回数据： ", xhr.response)
        end


        if xhr.status == 200 then

            local jdata = app.Json.decode(xhr.response)


            -- 回调数据
            if callback then
                callback(Http.Response.new(xhr.status, jdata), self.request)
            end

        else
            if app.config.DEBUG then
                print("responsecode: " .. xhr.status)
            end
        end
    end

    --local sessionId = qy.Model.User:getSessionId()
    --if sessionId then
      --  xhr:setRequestHeader("PHPSESSID", sessionId)
    --end

    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr:open(self.request.method, self.request.url:toStr())
    xhr:registerScriptHandler(onReadyStateChange)

    xhr:send(self.request:getParamsStr())
end

function Http.Request:ctor(params, method)
    self.url = self:URL()
    if params.p then self.url.path = params.p .. ".php" end
    self.params = params
    self.method = method or Http.POST
end

function Http.Request:URL()
    return {
        scheme = app.config.SERVER_SCHEME,
        domain = app.config.SERVER_DOMAIN,
        port = app.config.SERVER_PORT,
        path = app.config.SERVER_PATH,

        toStr = function(self)
            return string.format("%s://%s:%s/%s", self.scheme, self.domain, self.port, self.path)
        end
    }
end

function Http.Request:getParamsStr()
    return self.method == Http.POST and app.Json.encode(self.params) or nil
end

-- data: 返回数据
-- request: 请求的对象
function Http.Response:ctor(code, data, request)
    self.code = code
    self.data = data
    self.request = request
end

return Http
