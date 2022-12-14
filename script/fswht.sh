#!/bin/sh
chooseFiled() {
    case $1 in
        "ci") field="๐ฆพ";;
        "cd") field="๐ข";;
        "package") field="๐ฆ";;
        "config") field="๐ง";;
        "container") field="๐ณ";;
        "test") field="๐งช";;
        "docs") field="๐";;
        "style") field="๐";;
        "refactor") field="๐งน";;
        "perf") field="๐";;
        "revert") field="โช";;
        "build") field="๐๏ธ";;
        "chore") field="๐ฉ";;
        "anounce") field="๐ข";;
        "chat") field="๐ฌ";;
        *) field="";;
    esac
}

chooseStatus() {
    case $1 in
        "success") status="โ";;
        "failure") status="โ";;
        "pending") status="โณ";;
        "running") status="๐";;
        "sos") status="๐";;
        "canceled") status="๐ซ";;
        "skipped") status="โญ";;
        "error") status="๐จ";;
        *) status="";;
    esac
}

while getopts ":f:s:w:t:b:h" opt
do
    case $opt in
        h) echo '
            Usage: exwht.sh [options]
            Options:
                -h  help
                -f  field, ci/cd/package/config/container/test/docs/style/refactor/perf/revert/build/chore
                -s  status, success/failure/pending/running/sos/canceled/skipped/error
                -w  who, will show in the message title
                -b  body, message body
                -t  token
            '
            exit 0;;
        f)
        chooseFiled $OPTARG
        ;;
        s)
        chooseStatus $OPTARG
        ;;
        w)
        who=$OPTARG
        ;;
        b)
        body=$OPTARG
        ;;
        t)
        token=$OPTARG
        ;;
        ":")
        echo "No argument value for option $OPTARG"
        ;;
        *)
        echo "Unknown error while processing options"
        ;;
        ?)
        echo "ๆช็ฅๅๆฐ"
        exit 1;;
    esac
done

bot_url="https://open.feishu.cn/open-apis/bot/v2/hook/$token"

requestBody="$field $status $who \n\n $body"

curl -X POST -H "Content-Type: application/json" \
	-d "{\"msg_type\":\"text\",\"content\":{\"text\":\"$requestBody\"}}" \
    $bot_url