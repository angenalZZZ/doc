-- curl -sw' %{time_total}s ' -4LXPOST 'http://localhost:7312/token' -H'Origin: http://localhost:7312' -H'Content-Type: application/x-www-form-urlencoded' -H'Authorization: Basic NzY2NDFhZGYtMzRiMC00YzVhLWIzOWQtMjMzNzBhYWFkODdkOjExMTExMQ==' -d'UserName=13028500025' --data-urlencode 'PassWord={"AccountPwd":"96e79218965eb72c92a549dd5a330112","ValidateCode":"111111","ValidateId":"111111"}' -d'grant_type=password'

-- wrk -t2 -c8 -d10s -T2s -s ./wrk-post-login.lua 'http://localhost:7312/token' -H'Origin: http://localhost:7312' -H'Content-Type: application/x-www-form-urlencoded' -H'Authorization: Basic NzY2NDFhZGYtMzRiMC00YzVhLWIzOWQtMjMzNzBhYWFkODdkOjExMTExMQ==' wrk-user-login.txt 2

-- wrk -t16 -c64 -d10s -T2s --latency -s ./wrk-post-login.lua 'http://localhost:7312/token' -H'Origin: http://localhost:7312' -H'Content-Type: application/x-www-form-urlencoded' -H'Authorization: Basic NzY2NDFhZGYtMzRiMC00YzVhLWIzOWQtMjMzNzBhYWFkODdkOjExMTExMQ==' wrk-user-login.txt 16

local threadI = 0
local threads = {}
-- userPassWord = '{"AccountPwd":"96e79218965eb72c92a549dd5a330112","ValidateCode":"111111","ValidateId":"111111"}'
local userPassWordEncoded = "%7B%22AccountPwd%22%3A%2296e79218965eb72c92a549dd5a330112%22%2C%22ValidateCode%22%3A%22111111%22%2C%22ValidateId%22%3A%22111111%22%7D"

-- wrk.headers["Authorization"] = ""
-- wrk.path = "/token"
wrk.method = "POST"

function setup(thread)
    thread:set('threadIdx', threadI)
    table.insert(threads, thread)
    threadI = threadI + 1
    -- print('Init', 'thread', thread:get('threadIdx'))
end

function init(args)
    -- args: <filename of users list> <number of threads, used to split data>
    local threadN, lineIdx = args[2], 0
    -- thread local variables
    filename, requestN, responseN = args[1], 0, 0
    userNum, userIdx, userCnt, userList = 0, 0, 0, {}
    for line in io.lines(filename) do
        -- a line for a user, remove special characters
        line = removeSpecialCharacters(line)
        -- add user to list
        if string.len(line) > 3 then
            if lineIdx % threadN == threadIdx then
                userList[userIdx], userIdx = line, userIdx + 1
            end
            lineIdx = lineIdx + 1
        end
    end
    userNum, userIdx, userCnt = userIdx, 0, lineIdx
end

request = function()
    requestN = requestN + 1
    if userNum == userIdx then
        userIdx = 0
    end
    userName, userIdx = userList[userIdx], userIdx + 1
    bodyData = 'UserName='..userName..'&PassWord='..userPassWordEncoded..'&grant_type=password'
    -- print('request.body:', userIdx, userName, bodyData)
    return wrk.format(wrk.method, wrk.path, wrk.headers, bodyData)
end

response = function(status, headers, body)
    responseN = responseN + 1
    -- print('response.status='..status..', response.body=', body)
    if status ~= 200 or not string.find(body, "token") then
        print('-- error status:', status, body)
        if status == 500 then
            wrk.thread:stop()
        end
    end
end

done = function(summary, latency, requests)
    print('Summary/errors:')
    print('  read:', '', summary.errors.read, '(total socket read errors)')
    print('  write:', summary.errors.write, '(total socket write errors)')
    print('  status:', summary.errors.status, '(total HTTP status codes > 399)')
    print('  connect:', summary.errors.connect, '(total socket connection errors)')
    print('  timeout:', summary.errors.timeout, '(total request timeouts)')
    print('Summary/thread:')
    for index, thread in ipairs(threads) do
        local msg = "thread: %d"
        print('', msg:format(thread:get('threadIdx')+1))
        msg = "%d/%d, %s"
        print('', '  read:', msg:format(thread:get('userNum'), thread:get('userCnt'), thread:get('filename')))
        msg = "%d requests, %d responses"
        print('', '   run:', msg:format(thread:get("requestN"), thread:get("responseN")))
    end
end

removeSpecialCharacters = function(s)
    s = string.gsub(s, "^%s*(.-)%s*$", "%1")
    s = string.gsub(s, string.char(239), "", 1)
    return s
end

encodeChinese = function(s)
    s = string.gsub(s, '([^%w%.%-])', function(c) return string.format('%%%02X', string.byte(c)) end)
    s = string.gsub(s, ' ', '+')
    return s
end
