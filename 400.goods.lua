
urimap = {
    "your api list", 
    "your api list",
    "your api list",
    "your api list",
    "your api list",
    "your api list",
}
    
methodmap = {
    "POST", 
    "POST",
    "POST",
    "GET",
    "GET",
    "GET",
}
    
params = {
      [[{"id":2}]], 
      [[{"spu_id":2,"type":1}]],
      [[{"id":2,"sku_id":7}]],
      "page=1&size=100",
      "",
      "",
}
    
math.randomseed(os.time())

init = function()
    print("------------商品详情--------------\n")
    local r = {}
    local path = ""
    local method = "get" -- 默认get

    wrk.headers["Enterprise-Hash"]= "ecd85280aa135bbd0108dd6aa424565a"
    wrk.headers["Token"]= "eyJpdiI6Ijc1OEZYMTZmTmpMQ2JhTlFmY0UzQUE9PSIsInZhbHVlIjoidGYrdlludFpKMXhSS0hPb3hiYmthdHhUT2tkTEpkYmxuajFRanc3MjA1UWFvOXlLRXhLcWRQR1wva2ZoZitkellqaTNcL2tkSUUwcTZqbks3ZUdtbTczREVONG9EblFrOWhVV0NtNU1TZ1NtZkI1aUdwa0VmUSt0RGxGZmlsNjZCMCIsIm1hYyI6IjFiM2M0YjAwNDJhMWU3YzI4MGRjZDFiNDMxYTNhNjBjNDE4ZGFmMzUwODZiNzJmMzI0N2I2MWRjNWI2N2ZiM2MifQ=="
   
    for i, v in ipairs(urimap) do
        path = v    -- 路径
        method = methodmap[i]  -- method

        if method == "POST" then
            wrk.headers["content-type"]= "application/json"
            wrk.body = params[i]
        end

        if method == "GET" and  params[i] ~= "" then
            path = v.."?"..params[i]
        end

        io.write(method, "---", params[i], "----", path, "\n")
        r[i] =  wrk.format(method, path)    
    end 

    req = table.concat(r)
end

request = function()
      return req
end
    
response = function(status, headers, body)  
    if status ~= 200 then
        print("status:", status)
        print("error:", body)
        wrk.thread:stop()
    else 
       -- print("body:", body)   
    end
end  

done = function(summary, latency, requests)

    local durations=summary.duration / 1000000    -- 执行时间，单位是秒
    local errors=summary.errors.status            -- http status不是200，300开头的
    local requests=summary.requests               -- 总的请求数
    local valid=requests-errors                   -- 有效请求数=总请求数-error请求数
  
    io.write("Durations:       "..string.format("%.2f",durations).."s".."\n")
    io.write("Requests:        "..summary.requests.."\n")
    io.write("Avg RT:          "..string.format("%.2f",latency.mean / 1000).."ms".."\n")
    io.write("Max RT:          "..(latency.max / 1000).."ms".."\n")
    io.write("Min RT:          "..(latency.min / 1000).."ms".."\n")
    io.write("Error requests:  "..errors.."\n")
    io.write("Valid requests:  "..valid.."\n")
    io.write("QPS:             "..string.format("%.2f",valid / durations).."\n")
    io.write("--------------------------\n")
  
end
    
    
