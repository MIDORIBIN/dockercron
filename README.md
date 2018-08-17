ここ最近、すべてのアプリケーションをDockerに閉じ込めることに嵌まっています。  

cron程度であれば、ホストのLinuxでやってもいいが、せっかくなのでDockerでやってみた。  

# 実行環境
Windows 10  
WSL  
Docker version 17.03.2-ce  

# 完成品
とりあえず完成品

```Docker:Dockerfile
FROM alpine
COPY myscript.sh /bin/myscript.sh
COPY root /var/spool/cron/crontabs/root
RUN apk --update add tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata && \
    rm -rf /var/cache/apk/*
RUN chmod +x /bin/myscript.sh
CMD crond -l 2 -f
```

```shell:myscript.sh
#!/bin/sh
echo "Hello Qiita"
```

```:root
* * * * * /bin/myscript.sh
```

# Dockerfile
ベースはalpine  
実行したいシェルスクリプトとcronの設定ファイルをコピー  
タイムゾーンを日本に変更  
実行したいファイルに実行権限を付与  
crondを実行  

# 実行
`docker run --rm -d cron`

実行しているかを確認するためにログを確認  
`docker logs container_name`

# まとめ
定時処理をdockerで実行できるようになった。  
冒頭で書いた通り、ホストのほうのcronでやってもあまり変わらない気がする。  
ただ、プロジェクトに依存するような定時処理の場合、dockerを用いたほうが管理しやすい気がする。

# あとがき
最初はWindows for Dockerでやっていたが、全く動かず３時間以上無駄にしてしまった。  
権限の問題なのか、全く同じコードでもWindows for Dockerでは動かなかった。  
Windowsでやる場合は十分ご注意を。
