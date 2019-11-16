cat imgs.txt | while read i
do
    docker save $i > img/$(basename $i)
done
