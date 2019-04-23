
urimap = {
    "your api",  
}
    
methodmap = {
    "POST",
}
    
params = {
      [[{"payment_channel":1,"user_coupon_id":0,"order_type":1,"good_data":[{"spu_id":5,"sku_id":27,"quantity":1,"type":1,"car_id":161}],"mem_uid":"","type":1,"delivery_name":"你好","delivery_mobile":"18200000000","delivery_address":"山东省淄博市博山区财富中心II期D座(光泰路4号附近)","zip_code":255200,"logistics_price":0,"user_address_id":130,"province":"山东省","city":"淄博市","area":"博山区"}]], 
}
    
math.randomseed(os.time())

init = function()
    print("------------增加订单--------------\n")
    local r = {}
    local path = ""
    local method = "get" -- 默认get

    wrk.headers["content-type"]= "application/json"
    wrk.headers["Enterprise-Hash"]= "ecd85280aa135bbd0108dd6aa424565a"
    wrk.headers["Token"]= "eyJpdiI6Ijc1OEZYMTZmTmpMQ2JhTlFmY0UzQUE9PSIsInZhbHVlIjoidGYrdlludFpKMXhSS0hPb3hiYmthdHhUT2tkTEpkYmxuajFRanc3MjA1UWFvOXlLRXhLcWRQR1wva2ZoZitkellqaTNcL2tkSUUwcTZqbks3ZUdtbTczREVONG9EblFrOWhVV0NtNU1TZ1NtZkI1aUdwa0VmUSt0RGxGZmlsNjZCMCIsIm1hYyI6IjFiM2M0YjAwNDJhMWU3YzI4MGRjZDFiNDMxYTNhNjBjNDE4ZGFmMzUwODZiNzJmMzI0N2I2MWRjNWI2N2ZiM2MifQ=="
    
    for i, v in ipairs(urimap) do
        path = v    -- 路径
        method = methodmap[i]  -- method

        if method == "POST" then
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

    
    
