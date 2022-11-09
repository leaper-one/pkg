#!/bin/sh
chooseFiled() {
    case $1 in
        "ci") field="🦾";;
        "cd") field="🚢";;
        "package") field="📦";;
        "config") field="🔧";;
        "container") field="🐳";;
        "test") field="🧪";;
        "docs") field="📚";;
        "style") field="💅";;
        "refactor") field="🧹";;
        "perf") field="🚀";;
        "revert") field="⏪";;
        "build") field="🏗️";;
        "chore") field="🔩";;
        *) field="";;
    esac
}

chooseStatus() {
    case $1 in
        "success") status="✅";;
        "failure") status="❌";;
        "pending") status="⏳";;
        "running") status="🏃";;
        "sos") status="🆘";;
        "canceled") status="🚫";;
        "skipped") status="⏭";;
        "error") status="🚨";;
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
        echo "未知参数"
        exit 1;;
    esac
done

requestBody="$field $status $who \n\n $body"
curl "https://webhook.exinwork.com/api/send?access_token=$token" \
-XPOST -H 'Content-Type: application/json' \
-d "{\"category\":\"PLAIN_TEXT\",\"data\":\"$requestBody\"}"