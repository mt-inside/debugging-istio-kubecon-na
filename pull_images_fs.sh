cat imgs.txt | while read i
do
    docker pull $i
    docker save $i > img/$(basename $i)
done
