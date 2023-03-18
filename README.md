# my_assistant

## 注册openai

略...

### 获取openai api token

## 创建 flutter 工程
```sh
flutter create -t app MyAssistant --project-name my_assistant --platforms android,ios,windows,linux,macos,web
```

### 使用http api 跑一把效果
```sh
# RESTful API 
curl https://api.openai.com/v1/chat/completions \       
  -H "Content-Type: application/json" \     
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{
    "model": "gpt-3.5-turbo",
    "messages": [{"role": "user", "content": "使用flutter编写openai 接口调用"}]
  }'
```

### 根据生成代码修改
生成一个聊天模式的chat gpt, 跑起来看效果还不错