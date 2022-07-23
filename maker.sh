[[ -z "${GIT_SECRET}" ]] && exit
Version="$1"
TagsDate="$(date +"%Y%m%d")"
UploadAgain()
{
    fail="n"
    ./github-release upload \
        --security-token "$GIT_SECRET" \
        --user ZyCromerZ \
        --repo binutils-maker \
        --tag ${Version}-${TagsDate}-up \
        --name "binutils-${Version}.tar.xz" \
        --file "binutils-${Version}.tar.xz" || fail="y"
    TotalTry=$(($TotalTry+1))
    if [ "$fail" == "y" ];then
        if [ "$TotalTry" != "5" ];then
            sleep 10s
            UploadAgain
        fi
    fi
}
UploadAgainB()
{
    fail="n"
    ./github-release upload \
        --security-token "$GIT_SECRET" \
        --user ZyCromerZ \
        --repo binutils-maker \
        --tag ${Version}-${TagsDate}-up \
        --name "binutils-${Version}.sha512" \
        --file "binutils-${Version}.sha512" || fail="y"
    TotalTry=$(($TotalTry+1))
    if [ "$fail" == "y" ];then
        if [ "$TotalTry" != "5" ];then
            sleep 10s
            UploadAgainB
        fi
    fi
}
# LinkDL="https://github.com/ZyCromerZ/binutils-maker/releases/download/${Version}-${TagsDate}-up/binutils-${Version}.tar.xz"

if [[ -e result/binutils-${Version}.date ]];then
    [[ $(cat result/binutils-${Version}.date) == "$TagsDate" ]] && echo "already done" && exit
fi

git clone git://sourceware.org/git/binutils-gdb.git -b ${Version} binutils-${Version} --depth=1

tar --exclude="binutils-${Version}/.git" -cJf binutils-${Version}.tar.xz binutils-${Version} && rm -rf binutils-${Version}

python3 writehash.py -f ${Version}
(
    git clone https://${GIT_SECRET}@github.com/ZyCromerZ/binutils-maker.git -b main
    cd binutils-maker
    git config --global user.name "ZyCromerZ"
    git config --global user.email "neetroid97@gmail.com"
    # mv ../binutils-${Version}.sha512 result/binutils-${Version}.sha512
    echo "${TagsDate}" > result/binutils-${Version}.date
    rm -rf result/placeholder
    git add . && git commit -sm 'update'
    git checkout -b ${Version}-${TagsDate}
    git tag ${Version}-${TagsDate}-up -m "update"
    git push --all  -f
    cd ..
)
chmod +x github-release
./github-release release \
    --security-token "$GIT_SECRET" \
    --user ZyCromerZ \
    --repo binutils-maker \
    --tag ${Version}-${TagsDate}-up \
    --name "binutils-${Version}-${TagsDate}" \
    --description "upload binutils-${Version}"
UploadAgain
UploadAgainB
rm -rf *