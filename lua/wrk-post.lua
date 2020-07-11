wrk.method = "POST"

wrk.headers["Content-Type"] = "application/x-www-form-urlencoded"
-- wrk.headers["Content-Type"] = "application/json"

wrk.headers["Authorization"] = "Basic NzY2NDFhZGYtMzRiMC00YzVhLWIzOWQtMjMzNzBhYWFkODdkOjExMTExMQ=="

wrk.body = 'grant_type=password&UserName=adminApi&PassWord=%7B%22AccountPwd%22%3A%2296e79218965eb72c92a549dd5a330112%22%2C%22ValidateCode%22%3A%22111111%22%2C%22ValidateId%22%3A%22111111%22%7D'
