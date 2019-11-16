# With 8 cores, take 1m50s

for i in img/*
do
    kind load image-archive "$i"
done
