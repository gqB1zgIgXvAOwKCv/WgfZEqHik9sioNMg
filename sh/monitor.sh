#!/bin/bash
web_name="网站名称"
url="https://example.com"
bot_token="3515345356:A456jaxr-u64A8-l6463s4-_m326364642654FZLpLM"
chat_id="62346256"

time="$(date "+%Y-%m-%d %H:%M:%S")"

code=$(curl -I -m 10 -o /dev/null -s -w %{http_code} $url)

while [ $code -eq 200 ]
do
	sleep 5m
	code=$(curl -I -m 10 -o /dev/null -s -w %{http_code} $url)
done


if [ $code -ne 200 ]
then
	service nginx restart
	systemctl restart php-fpm
	curl -s -d "text=${time} 时 ${web_name} 访问异常,状态码为: ${code}，已重启Nginx和PHP" -X POST "https://api.telegram.org/bot${bot_token}/sendMessage?chat_id=${chat_id}"
    sleep 15
	code=$(curl -I -m 10 -o /dev/null -s -w %{http_code} $url)
	if [ $code -eq 200 ]
	then
	curl -s -d "text=${web_name} 已恢复正常" -X POST "https://api.telegram.org/bot${bot_token}/sendMessage?chat_id=${chat_id}"
	exit 4
	else
	curl -s -d "text=${web_name} 异常依旧，状态码为：${code}，请及时修复" -X POST "https://api.telegram.org/bot${bot_token}/sendMessage?chat_id=${chat_id}"
	fi
fi